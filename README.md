# ax6000-custom

Xiaomi Router AX6000 customization

Copy data to router

```
mkdir /tmp/custom
cd /tmp/custom
curl -L -O https://github.com/toxeh/ax6000-custom/archive/refs/tags/v0.0.1.tar.gz
tar -xzvf v0.0.1.tar.gz
cp -R ax6000-custom-0.0.1/data/* /data
```
Then crontab
```
*/2 * * * * /data/custom/all-to-cron.sh >/dev/null 2>&1
```