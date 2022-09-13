import json
import logging
import socket
import time
import random
from http.server import BaseHTTPRequestHandler, HTTPServer, HTTPStatus

import mysql.connector
import prometheus_client

REQUEST_TIME = prometheus_client.Histogram('response_latency_seconds', 'Response latency (seconds)')


def _insert_record(path, body):
    db = mysql.connector.connect(host='172.17.0.1', database='requests', user='root', password='root', port=3306)
    sql = "INSERT INTO requests (uri, body) VALUES (%s, %s)"
    val = (path, body)
    cursor = db.cursor()
    cursor.execute(sql, val)
    db.commit()


class S(BaseHTTPRequestHandler):
    registry = prometheus_client.exposition.MetricsHandler.registry

    def _set_response(self):
        self.send_response(HTTPStatus.OK)
        self.send_header("Content-Type", "text/html")
        self.end_headers()

    @REQUEST_TIME.time()
    def _metrics(self):
        time.sleep(random.random())
        return prometheus_client.exposition.MetricsHandler.do_GET(self)

    def do_GET(self):
        if self.path == "/metrics":
            self._metrics()

        if self.path == "/db":
            db = mysql.connector.connect(host='172.17.0.1', database='requests', user='root', password='root', port=3306)
            sql = "SELECT * FROM requests"
            cursor = db.cursor()
            cursor.execute(sql)
            result = cursor.fetchall()
            message = []
            for row in result:
                t = ({"id": row[0], "path": row[1], "message": row[2], "datetime": row[3].strftime("%Y-%m-%d %H:%M:%S")})
                message.append(t)
            cursor.close()

            self._set_response()
            self.wfile.write(bytes((json.dumps(message)).encode('utf-8')))

    def do_POST(self):
        hostname = socket.gethostname()
        ip = socket.gethostbyname(hostname)

        log_format = '%(asctime)s %(filename)s: %(message)s'
        logging.basicConfig(filename='example.log', level=logging.INFO, format=log_format)
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length).decode('utf-8')

        _insert_record(self.path, post_data)
        logging.info('ip: %s, path: %s, body: %s' % (ip, self.path, post_data))

        message = {"ip": ip, "message": post_data}

        self._set_response()
        self.wfile.write(bytes((json.dumps(message)).encode('utf-8')))


def run(server_class=HTTPServer, handler_class=S):
    server_address = ("0.0.0.0", 8000)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()


if __name__ == '__main__':
    run()
