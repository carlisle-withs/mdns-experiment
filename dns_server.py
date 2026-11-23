import sys

from dnslib import A, DNSRecord, QTYPE, RR
from dnslib.server import BaseResolver, DNSServer

LOCAL_HOST = "myflask.local."
LOCAL_IP = "192.168.137.1"


class Resolver(BaseResolver):
    def __init__(self, upstream: str):
        self.upstream = upstream

    def resolve(self, request, handler):
        qname = str(request.q.qname).lower()
        print(f"查询来源 {handler.client_address[0]} -> {qname}", flush=True)
        reply = request.reply()
        if qname == LOCAL_HOST or qname.endswith("." + LOCAL_HOST):
            if request.q.qtype == QTYPE.A:
                reply.add_answer(RR(request.q.qname, QTYPE.A, rdata=A(LOCAL_IP), ttl=10))
            return reply
        try:
            return DNSRecord.parse(request.send(self.upstream, timeout=3))
        except Exception:
            return reply


if __name__ == "__main__":
    upstream = sys.argv[1] if len(sys.argv) > 1 else "223.5.5.5"
    resolver = Resolver(upstream)
    server = DNSServer(resolver, address="0.0.0.0", port=53)
    print(f"DNS 服务器启动: 0.0.0.0:53 (myflask.local -> {LOCAL_IP}, 其余转发 {upstream})", flush=True)
    server.start()
