This package contains a Near Node and a local wallet.

**Wallet URL**: [wallet.near.dappnode](http://wallet.near.dappnode)

**Stake URL**: [near.dappnode](http://near.dappnode)

The backup contains de following files:
- config.json
- node_key.json
- validator_key.json

When you already have the account id and the node and/or validator keys you can configure them on the Config tab. Take data from the files above.

⚠️**Important**⚠️
You will have to wait for your node to synchronize to connect the wallet to your node.

It includes a Grafana dashboard for the [DMS](http://my.dappnode/#/installer/dms.dnp.dappnode.eth)

🛠️**Troubleshooting**🛠️
If your node doesn't get peers, make sure your router has the following ports open:
**Ports**: Expose 24567 (TCP and UDP)