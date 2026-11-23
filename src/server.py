import time

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def index():
    return (
        "<h1>mDNS 实验成功!</h1>"
        f"<p>你通过 <b>{request.host}</b> 访问到了 Flask 服务</p>"
        f"<p>服务器时间: {time.strftime('%Y-%m-%d %H:%M:%S')}</p>"
    )


@app.route("/health")
def health():
    return {"status": "ok"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
