# The suggestion "uWSGI HTTP is slow" is *WRONG*

~~Flask with uWSGI @ HTTP seems to sleep for exactly 1 sec on a file post.
Note that without file posts these measurements are even for all approaches.~~

This is actually because of `curl` and HTTP/1.1.

`curl` will set `Expect: 100-continue` as a request header,
and will wait for a `100` response from the server to allow it to send a file which is potentially heavy.

To handle this request header by uWSGI, we can put this configuration in the [uwsgi.ini](uwsgi.ini) file.

```diff
 [http]
 ini = :uwsgi
 http = 0.0.0.0:80
+http-manage-expect = 1
```

Thank [@awelzel](https://github.com/unbit/uwsgi/issues/2129#issuecomment-592935917) for this knowledge.

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

At first, I thought there is a 1 sec delay here like:

```diff
-$ time curl -s -XPOST -F file=@LICENSE localhost:5002 > /dev/null
-curl -s -XPOST -F file=@LICENSE localhost:5002 > /dev/null  0.01s user 0.01s system 1% cpu 1.063 total
```

*BUT*, with `http-manage-expect = 1`, I got:

```diff
+$ time curl -s -XPOST -F file=@LICENSE localhost:5002 > /dev/null
+curl -s -XPOST -F file=@LICENSE localhost:5002 > /dev/null  0.01s user 0.01s system 29% cpu 0.068 total
```

### uWSGI @ WSGI (with nginx)

```bash
$ time curl -s -XPOST -F file=@LICENSE localhost:5003 > /dev/null
curl -s -XPOST -F file=@LICENSE localhost:5003 > /dev/null  0.01s user 0.01s system 31% cpu 0.062 total
```
