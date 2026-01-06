# 2603-HAYASHI.Yuki
2026年3月卒業  林佑樹

## Overview
本リポジトリは、10Gbpsネットワーク上のDockerコンテナ環境において、IPsec通信（strongSwan）の性能ボトルネックを調査した卒業研究の実験データおよびスクリプトです。
実験により、コンテナネットワーク（veth/bridge）特有のパケット順序逆転（OOO）がTCP再送の原因であることを特定し、MTUサイズ拡張による改善手法を提案しています。

## Description
Docker環境でIPsecを利用すると、物理帯域が十分であってもスループットが大幅に低下する現象が確認されています。本研究では、以下の点を明らかにしました。

- **課題:** コンテナのveth/bridge経路とIPsec（XFRM）の組み合わせにより、パケット順序逆転（Out-of-Order）が多発し、TCP再送が誘発される。
- **検証:** `ss -ti` コマンドによるTCP統計解析で、パケットロスではなくOOOが原因であることを特定。
- **解決策:** コンテナおよびホストのMTUを **64000** に設定することで、パケット処理数（PPS）を削減し、OOOを抑制してスループットを劇的に改善できることを実証。

## Requirements
本実験は以下の環境で動作確認を行いました。

- **Hardware:** 10Gbps Ethernet (直結環境)
- **OS:** Ubuntu 22.04 LTS / FreeBSD
- **Container Runtime:** Docker Engine [Version]
- **VPN Software:** strongSwan [Version]
- **Benchmark Tool:** iperf3
- **Network Tools:** iproute2 (ss, ip), ethtool, tcpdump
