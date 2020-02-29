# Flask with uWSGI @ HTTP is slow when POSTing a file

Flask with uWSGI @ HTTP seems to sleep for exactly 1 sec on a file post.
Note that without file posts these measurements are even for all approaches.

**Apologies in advance if this issue is due to Flask.**

## Experiment

```bash
$ docker-compose up
```

You may see this delay when uploading any kind of files.
Here, I uploaded the `LICENSE` file on this repo to show the delay.

### Bare Flask

```bash
$ time curl -s -XPOST -F file=@LICENSE localhost:5001 > /dev/null
curl -s -XPOST -F file=@LICENSE localhost:5001 > /dev/null  0.01s user 0.01s system 30% cpu 0.067 total
```

### uWSGI @ HTTP

```bash
$ time curl -s -XPOST -F file=@LICENSE localhost:5002 > /dev/null
curl -s -XPOST -F file=@LICENSE localhost:5002 > /dev/null  0.01s user 0.01s system 1% cpu 1.063 total
```

### uWSGI @ WSGI (with nginx)

```bash
$ time curl -s -XPOST -F file=@LICENSE localhost:5003 > /dev/null
curl -s -XPOST -F file=@LICENSE localhost:5003 > /dev/null  0.01s user 0.01s system 31% cpu 0.062 total
```
