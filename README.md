<h1 align="center">BlockScout</h1>
<p align="center">Blockchain Explorer for inspecting and analyzing EVM Chains.</p>
<div align="center">

[![Blockscout](https://github.com/blockscout/blockscout/workflows/Blockscout/badge.svg?branch=master)](https://github.com/blockscout/blockscout/actions) [![Join the chat at https://gitter.im/poanetwork/blockscout](https://badges.gitter.im/poanetwork/blockscout.svg)](https://gitter.im/poanetwork/blockscout?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

</div>

BlockScout provides a comprehensive, easy-to-use interface for users to view, confirm, and inspect transactions on EVM (Ethereum Virtual Machine) blockchains. This includes the POA Network, xDai Chain, Ethereum Classic and other **Ethereum testnets, private networks and sidechains**.

See our [project documentation](https://docs.blockscout.com/) for detailed information and setup instructions.

Visit the [POA BlockScout forum](https://forum.poa.network/c/blockscout) for FAQs, troubleshooting, and other BlockScout related items. You can also post and answer questions here.

You can also access the dev chatroom on our [Gitter Channel](https://gitter.im/poanetwork/blockscout).

## About BlockScout

BlockScout is an Elixir application that allows users to search transactions, view accounts and balances, and verify smart contracts on the Ethereum network including all forks and sidechains.

Currently available full-featured block explorers (Etherscan, Etherchain, Blockchair) are closed systems which are not independently verifiable.  As Ethereum sidechains continue to proliferate in both private and public settings, transparent, open-source tools are needed to analyze and validate transactions.

## Supported Projects

BlockScout supports a number of projects. Hosted instances include POA Network, xDai Chain, Ethereum Classic, Sokol & Kovan testnets, and other EVM chains. 

- [List of hosted mainnets, testnets, and additional chains using BlockScout](https://docs.blockscout.com/for-projects/supported-projects)
- [Hosted instance versions](https://docs.blockscout.com/about/use-cases/hosted-blockscout)


## Getting Started

See the [project documentation](https://docs.blockscout.com/) for instructions:
- [Requirements](https://docs.blockscout.com/for-developers/information-and-settings/requirements)
- [Ansible deployment](https://docs.blockscout.com/for-developers/ansible-deployment)
- [Manual deployment](https://docs.blockscout.com/for-developers/manual-deployment)
- [ENV variables](https://docs.blockscout.com/for-developers/information-and-settings/env-variables)
- [Configuration options](https://docs.blockscout.com/for-developers/configuration-options)


## Acknowledgements

We would like to thank the [EthPrize foundation](http://ethprize.io/) for their funding support.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution and pull request protocol. We expect contributors to follow our [code of conduct](CODE_OF_CONDUCT.md) when submitting code or comments.

## License

[![License: GPL v3.0](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## My installation (2021.09.20)

### 1．升级node到14.17.6

* sudo apt-get update -y
* sudo apt-get -y install build-essential libssl-dev
* curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

* 修改~/.bashrc:
```
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 
```
* nvm install 14.17.6

### 2. 安装postgresql-12

* wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
* echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list

* sudo apt update
* sudo apt -y install postgresql-12 postgresql-client-12

* 修改postgres密码的话，需要先取消密码

* 首先要修改/etc/postgresql/12/main/pg_hba.conf 中：
```
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
```
* 重新启动postgresql的service后，可以修改密码
* sudo systemctl start(stop) postgresql.service
* sudo su - postgres
* psql –h 127.0.0.1 –p 5434
* alter user postgres with passworld ‘wangyi’

* 恢复修改/etc/postgresql/12/main/pg_hba.conf 中：
```
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
```

### 3. 安装erlang 最新版24.0.5

* wget -O- https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo apt-key add -
* echo "deb https://packages.erlang-solutions.com/ubuntu bionic contrib" | sudo tee /etc/apt/sources.list.d/rabbitmq.list

* sudo apt update
* sudo apt install erlang

### 4. 安装elixir 1.12.3

* 下载 https://github.com/elixir-lang/elixir/releases/download/v1.12.3/Precompiled.zip

* mkdir –p /opt/elixir
* unzip Precompiled.zip –d /opt/elixir

### 5. 正式编译安装

* git clone https://github.com/poanetwork/blockscout
* cd blockscout

* export DATABASE_URL=postgresql://postgres:wangyi@localhost:5434/blockscout
* export SECRET_KEY_BASE=VTIB3uHDNbvrY0+60ZWgUoUBKDn9ppLR8MI4CpRz4/qLyEFs54ktJfaNT6Z221No

* export ETHEREUM_JSONRPC_VARIANT=ganache
* export ETHEREUM_JSONRPC_HTTP_URL=http://localhost:8545
* export ETHEREUM_JSONRPC_WS_URL=ws://localhost:8546

* HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix do deps.get, local.rebar --force, deps.compile, compile
* mix do ecto.create, ecto.migrate

* mix phx.digest.clean

* cd apps/block_scout_web/assets; npm install && node_modules/webpack/bin/webpack.js --mode production; cd -
* cd apps/explorer && npm install; cd -
* mix phx.digest
* cd apps/block_scout_web; mix phx.gen.cert blockscout blockscout.local; cd -

* 修改/etc/hosts， 加入 blockscout and blockscout.local 
```
127.0.0.1       localhost blockscout blockscout.local
255.255.255.255 broadcasthost
::1             localhost blockscout blockscout.local
```
* mix phx.server

### 6. 重新启动

* export DATABASE_URL=postgresql://postgres:wangyi@localhost:5434/blockscout
* export SECRET_KEY_BASE=VTIB3uHDNbvrY0+60ZWgUoUBKDn9ppLR8MI4CpRz4/qLyEFs54ktJfaNT6Z221No

* export ETHEREUM_JSONRPC_VARIANT=ganache
* export ETHEREUM_JSONRPC_HTTP_URL=http://localhost:8545
* export ETHEREUM_JSONRPC_WS_URL=ws://localhost:8546

* mix do ecto.drop, ecto.create, ecto.migrate
* mix phx.server

