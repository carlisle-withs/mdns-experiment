import argparse
import socket
import time

from zeroconf import ServiceInfo, Zeroconf


def detect_lan_ip() -> str:
    """通过默认路由探测本机局域网出口 IP（不发包）。"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    finally:
        s.close()


def main():
    parser = argparse.ArgumentParser(description="在局域网注册一个 .local 域名（mDNS 应答器）")
    parser.add_argument("--name", default="myflask", help="域名主体，不含 .local 后缀，默认 myflask")
    parser.add_argument("--ip", default=None, help="要宣告的局域网 IP，多个用逗号分隔，默认自动探测")
    parser.add_argument("--port", type=int, default=5000, help="SRV 记录中的端口，默认 5000")
    args = parser.parse_args()

    ips = [s.strip() for s in (args.ip or detect_lan_ip()).split(",")]
    zc = Zeroconf(interfaces=ips)
    info = ServiceInfo(
        "_http._tcp.local.",
        f"{args.name}._http._tcp.local.",
        addresses=[socket.inet_aton(ip) for ip in ips],
        port=args.port,
        server=f"{args.name}.local.",
        properties={"path": "/"},
    )
    zc.register_service(info)
    print(f"mDNS 已注册: {args.name}.local -> {', '.join(ips)} (端口 {args.port})，Ctrl+C 退出")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        pass
    finally:
        zc.unregister_service(info)
        zc.close()
        print("mDNS 已注销")


if __name__ == "__main__":
    main()
