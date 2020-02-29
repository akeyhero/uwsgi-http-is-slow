from datetime import datetime
from flask import Flask, request

app = Flask(__name__)


@app.route('/', methods=['POST'])
def index():
    started = datetime.now()
    request.files
    finished = datetime.now()
    return 'Took: ' + str(finished - started)
