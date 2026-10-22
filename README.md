# uptime

Бесплатный мониторинг сайтов через GitHub Actions. Каждые 10 минут проверяются адреса из `urls.txt` (таймаут 20 с, 2 повтора) и срок TLS-сертификата (предупреждение, если меньше 14 дней). Если адрес недоступен, запуск падает, и GitHub присылает письмо владельцу.

## Что проверяется
| Адрес | Ожидается |
|---|---|
| https://dushnila-pro.ru/ | 2xx/3xx |
| https://dushnila-pro.online/ | 2xx/3xx (редирект) |
| https://api.dushnila-pro.ru/auth/v1/health | 401 — сервер Душнилы жив (без ключа отвечает 401) |
| https://psycanvas.ru/ | 2xx/3xx |
| https://api.psycanvas.ru/health | 2xx |
| https://polina-vysokova-psy.ru/ | 2xx/3xx |
| https://polina-vysokova-psy.online/ | 2xx/3xx (редирект) |
| https://softwaretestlab.ru/ | 2xx/3xx |

## Как добавить адрес
Добавьте строку в `urls.txt`: `https://адрес/` и, при необходимости, через пробел ожидаемые коды (`200,301`). Только публичные адреса, никаких ключей и паролей — репозиторий публичный.

## Keepalive
GitHub отключает расписание в публичных репозиториях после 60 дней без коммитов. Workflow `keepalive` раз в месяц коммитит метку времени в `.keepalive`.
