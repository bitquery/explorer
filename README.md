Blockchain Unified Explorer
============

TLDR; Try this: [https://explorer.bitquery.io]()

Bitquery Explorer is built by [Bitquery.io](https://bitquery.io) using 
[Bitquery Widgets](https://github.com/bitquery/widgets) as user interface
components. The backend is supplied by the GraphQL interface.

## Vision

We are building blockchain explorer. In most extent, all blockchain explorers are similar - they
all shows blocks, transactions, operations, coin transfers and other technical information of the blockchain state.
Almost all of them are specific for the blockchain protocol, in rare cases explorer covers blockchain networks
with different protocols.

Why are we building just one more blockchain explorer? We believe, that it will give access to much larger amount of
valuable information, in the manner, that was not possible before. There are many layers of data in a blockchain, as
network, block, transaction, transfer, operation, address and others, depending on protocol. Technically giving access
to all of them seems sufficient, but it is not. To see the full picture, you need to look on information, gathered from 
several of these layers in combination. Analytical capabilities are the key to our approach.

We use multi-dimensional (OLAP) analytical database to display most of the information in explorer. This gives us capability
to aggregate data by dimensions as time, block, address, token, and others. Aggregation helps to build graphs,
diagrams and present data in the way, that allows to see the bigger picture rather than just numbers.

Explorer does not  show the data just in the form of 'database records', or 'tables''. There are more powerfull
ways of presenting information, as graphs, diagrams, plots, maps, histograms. The way how we have to present information
depends on typical ways of working with this kind of information, and very dependent on the problem we want to solve.
For example, transfers of the address can be presented as the list, table, graph by time period, graph, tree, and in many other
ways. There is no single 'right' way to make this presentation, as for different tasks you may need a special way to work with this data.

That's why flexibility and adoption to a particular task is another key feature of Bitquery explorer. Explorer is implemented as client-side Web application, based on Javascript. It is built from independent parts, 
'widgets', or components ( see [Bitquery Widgets](https://github.com/bitquery/widgets) for details). The parts are independent, they can be 
placed on other web pages, and will work the same way as in explorer. Widgets can be composed to build generic or specialized dashboards, 
customize and personalize explorer pages. In extreme, they allow to build completely specialized explorer, which will be ideal
to solve some particular task.

We are following the following principles to execute the project:

* explorer is for users, not for the blockchains;
* we are flexible about the information retrieval and presentation, as it dependent on tasks and problems to solve;
* explorer is modular, as particular tasks may require specialized view of data, dashboards, or dedicated tools;
* many blockchains are very similar in protocol or concept, there is no reason to explore them differently;
* new protocols appear every day, extending the explorer should be easy, as well as integrating this changes into UI;
* community is open to extendm enhance explorer, or build their open, all presentation components are open sourced.


## Features

- Supports multiple blockchains. The full list available on the Search button, and counting
- Unified extensible user interface. You can use [Bitquery Widgets](https://github.com/bitquery/widgets) 
with arbitrary queries to data, thus making custom interfaces and explorers
- Analytical view of data. Shows many types of data aggregations, slices and relations, which 
typical blockchain explorers do not
- Free to use, extend, deploy and customize according to [MIT License](https://github.com/bitquery/explorer/blob/master/LICENSE)

## Installation

Explorer is a typical [Ruby on Rails](https://rubyonrails.org/) project.
There is a minimum server-side logic used, mostly this is a set of pages with 
javascript loading [Bitquery Widgets](https://github.com/bitquery/widgets).


Requirements are:

- Ruby v.2.6.3
- Rails v.6.0.1

Refer to the [Rails Installation Guide](https://guides.rubyonrails.org/) how to setup environment and run the project.

No database or backend is required, this is pure set of front-end UI.


## Deployment

For server deployment we use [Capistrano](https://github.com/capistrano/capistrano).

To pre-configure the server, the following may be needed:

####  Ruby installation

```
sudo apt-get install ruby-all-dev git gcc zlib1g-dev make mysql-client default-libmysqlclient-dev g++ puma libssl1.0-dev


see https://github.com/postmodern/ruby-install#readme

wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
tar -xzvf ruby-install-0.7.0.tar.gz
cd ruby-install-0.7.0/

sudo make install
sudo ruby-install --system ruby 2.6.3
sudo gem install bundler
```

re-login:
```
> ruby --version
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-linux]
```

####  Capistrano installation

```
sudo adduser deploy
sudo passwd -l deploy

sudo mkdir /var/www
sudo mkdir /var/www/explorer
sudo chown -R deploy:deploy /var/www/explorer
```

### Nodejs installation

```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update && sudo apt-get install yarn
```

### Build widgets

```
yarn upgrade widgets
yarn install --check-files
```

### Run capistrano

Setup local name bitquery in your /etc/hosts file before running:

```
cap production deploy
```

### Puma run as service

Look [scripts/explorer.service](explorer.service) for details

Replace `<PUT YOUR SECRET HERE>` with the secret for service.

```
sudo vim /etc/systemd/system/explorer.service
sudo systemctl enable explorer
```

## License
>You can check out the full license [here](https://github.com/bitquery/explorer/blob/master/LICENSE)

This project is licensed under the terms of the **MIT** license.

You are encouraged to build your ownb explorers, data analytical web sites, embed part of this project on your web site
and more!