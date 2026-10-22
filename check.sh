#!/usr/bin/env bash
set -u
fail=0
while read -r url expect; do
  [[ -z "$url" || "$url" == \#* ]] && continue
  code=$(curl -s -o /dev/null -m 20 --retry 2 --retry-delay 5 --retry-all-errors -w '%{http_code}' "$url")
  ok=0
  if [[ -n "${expect:-}" ]]; then [[ ",$expect," == *",$code,"* ]] && ok=1
  else [[ "$code" =~ ^[23] ]] && ok=1; fi
  if [[ $ok == 1 ]]; then echo "OK   $code $url"; else echo "::error::DOWN $code $url"; fail=1; fi
  host=$(echo "$url" | sed -E 's#https://([^/]+).*#\1#')
  end=$(echo | timeout 20 openssl s_client -servername "$host" -connect "$host:443" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
  if [[ -n "$end" ]]; then
    days=$(( ($(date -d "$end" +%s) - $(date +%s)) / 86400 ))
    if (( days < 14 )); then echo "::warning::TLS $host истекает через $days дн."; fi
  fi
done < urls.txt
exit $fail
