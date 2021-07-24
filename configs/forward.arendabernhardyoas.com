$TTL 86400
@   IN  SOA     arendabernhardyoas.com. root.arendabernhardyoas.com. (
        2014071001  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)

        IN  NS      arendabernhardyoas.com.
        IN  A       172.17.17.250
;        IN  A       192.168.43.68

        IN  MX 10   mail.arendabernhardyoas.com.
mail    IN  A       172.17.17.250

file    IN  A       172.17.17.250

router  IN  A       172.17.17.172
client1  IN  A       172.17.17.249
client2  IN  A       172.17.17.248
