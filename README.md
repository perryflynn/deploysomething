
Simple shell script to deploy stuff to a server. Called by cron.

## Example: Lets Encrypt certificate deployment

Install this script on the target server.

```sh
https://github.com/perryflynn/deploysomething.git /etc/letsencrypt
cd /etc/letsencrypt
cp config.skel config
$EDITOR config # Edit config file
```

Place source key files.

```sh
# https://le.srv.example.com/FsCmqcYQixau2zeiIm/
echo FsCmqcYQixau2zeiIm > awesome-certificate
# https://le.srv.example.com/FsCmqcasfkju2zeiIm/
echo FsCmqcasfkju2zeiIm > another-certificate
```

Create after-download-hooks in `post-download.d`.

Example: Reload nginx after download certificates.

## Requirements

- HTTPS Deployment Server (nginx?)
- Activated autoindex for folders
- One subfolder inside the vhost per certificate

## Output

```
root@vitruvius:/etc/letsencrypt# ./cron.sh 
--> cert-metrics.prv.example.com
total 40K
2097828 4.0K drwxr-xr-x 2 root root 4.0K Nov  2 17:44 ./
2097155 4.0K drwxr-xr-x 5 root root 4.0K Nov  2 17:44 ../
2098475 4.0K -rw------- 1 root root 1.7K Nov  1 21:44 ca.cer
2098507 4.0K -rw------- 1 root root 3.4K Nov  1 21:44 fullchain.cer
2097857 4.0K -rw------- 1 root root 1.1K Nov  2 17:44 index.html
2098526 4.0K -rw------- 1 root root 1.8K Nov  1 21:44 metrics.prv.example.com.cer
2098529 4.0K -rw------- 1 root root  529 Nov  1 21:44 metrics.prv.example.com.conf
2098532 4.0K -rw------- 1 root root  952 Nov  1 21:42 metrics.prv.example.com.csr
2098534 4.0K -rw------- 1 root root  175 Nov  1 21:42 metrics.prv.example.com.csr.conf
2098536 4.0K -rw------- 1 root root 1.7K Nov  1 21:42 metrics.prv.example.com.key

--> cert-prv.example.com
total 40K
2098540 4.0K drwxr-xr-x 2 root root 4.0K Nov  2 17:44 ./
2097155 4.0K drwxr-xr-x 6 root root 4.0K Nov  2 17:44 ../
2098550 4.0K -rw------- 1 root root 1.7K Oct 30 00:49 ca.cer
2098551 4.0K -rw------- 1 root root 3.5K Oct 30 00:49 fullchain.cer
2098546 4.0K -rw------- 1 root root 1.1K Nov  2 17:44 index.html
2098552 4.0K -rw------- 1 root root 1.9K Oct 30 00:49 prv.example.com.cer
2098553 4.0K -rw------- 1 root root  566 Oct 30 00:49 prv.example.com.conf
2098554 4.0K -rw------- 1 root root 1.1K Oct 30 00:47 prv.example.com.csr
2098555 4.0K -rw------- 1 root root  246 Oct 30 00:47 prv.example.com.csr.conf
2098556 4.0K -rw------- 1 root root 1.7K Oct 30 00:47 prv.example.com.key

--> Hook 
[ ok ] Reloading nginx configuration (via systemctl): nginx.service.

Done.
```

