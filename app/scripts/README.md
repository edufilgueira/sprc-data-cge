# Rotinas diárias

O diretório `scripts` contém as rotinas que são executadas por fora da aplicação.

Também contém um exemplo de crontab com as rotinas que devem ser executadas automaticamente:

```sh

# Diariamente, às 01:00am, 06:00am, 19:00pm, atualiza informações de despesas (NPF, NED, NLD, NPD, BudgetBalance).
0 1,6,19 * * * /app/sprc-data/current/app/scripts/expenses_daily_update.sh

Diariamente, às 23:00pm, atualiza informações de receitas. (Receitas do Poder Executivo, Transferências e Receitas Registradas)
0 23 * * * /app/sprc-data/current/app/scripts/revenues.sh

# Diariamente, às 04:30am, 20:00pm, atualiza os contratos que sofreram alterações desde a última sincroniazação.
30 4, 20 * * * /app/sprc-data/current/app/scripts/contracts_daily_update.sh

# Diariamente, às 05:30am, atualiza apenas os convênios ativos com infos do eparceria.
30 5 * * * /app/sprc-data/current/app/scripts/eparcerias_daily_update.sh

# Semanalmente, sábado às 01am, atualiza todos os convênios com infos do eparceria.
0 1 * * SAT /app/sprc-data/current/app/scripts/eparcerias_weekly_update.sh

# Semanalmente, sábado às 01am, atualiza todos os convênios com infos do eparceria.
0 1 * * SAT /app/sprc-data/current/app/scripts/city_undertakings_daily_update.sh

# Diariamente, às 19:00pm, atualiza bens imóveis.
0 19 * * * /app/sprc-data/current/app/scripts/real_states_daily_update.sh

# Diariamente, às 20:00pm, atualiza obras (dae e der).
0 20 * * * /app/sprc-data/current/app/scripts/constructions_daily_update.sh

# Diariamente, às 2:50am, atualiza credores.
50 2 * * * /app/sprc-data/current/app/scripts/creditors_daily_update.sh

```

Os scripts têm todos a mesma estrtura, como por exemplo:

```sh

#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.4.9@sprc-data

# Mata outros processos de rotina que podem estar rodando para iniciarmos um novo.
pkill -f 'integration:contracts:daily_update'

# Inicia processo...
cd /app/sprc-data/current && RAILS_ENV=production nohup bin/rake integration:contracts:daily_update &


```

Em alguns casos, o código Rails é rodado diretamente, sem passar por rake, como por exemplo:

```sh
#!/usr/bin/env bash

# load rvm ruby
source /usr/local/rvm/environments/ruby-2.4.9@sprc-data

# Mata outros processos de rotina que podem estar rodando para iniciarmos um novo.
pkill -f 'Integration::Revenues::ImporterWorker.perform_async'

# Inicia processo...
cd /app/sprc-data/current && RAILS_ENV=production bin/rails runner 'Integration::Revenues::ImporterWorker.perform_async'

```
