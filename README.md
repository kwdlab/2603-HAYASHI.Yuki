# 2603-HAYASHI.Yuki
2026年3月卒業  林佑樹

## Overview
本リポジトリは、10Gbps級ネットワーク環境でDockerコンテナ上にIPsec（strongSwan）を導入した際に発生する性能劣化を対象に、原因分析と改善策の検証を行った卒業研究の成果物（集計データ・再現用スクリプト）をまとめたものです。  
特に、コンテナのveth/bridge 経路と LinuxのXFRM（IPsec）処理が組み合わさることで Out-of-Order（OOO)が増え、これが TCP再送（Retr）とスループット低下を引き起こすという因果関係に着目しました。さらに、MTU拡張、replay_window拡大を通し、OOOと再送を低減して性能を改善できることを、iperf3/ss統計など複数の観測から示します。

## Description
Dockerコンテナ環境におけるIPsec（strongSwan/XFRM）の適用が、通信性能に与える影響をiperf3の計測結果（Throughput/Retr)を中心に整理した実験データ集です。10Gbps環境を前提に、Docker（veth/bridge・VM・ホスト直など、実行環境の違いによってスループット低下やTCP再送（Retr）の増加がどの程度発生するかを比較し、性能劣化が特定の経路・条件で顕著になることを示します。さらに、MTU拡張（例:1500→64000）など設定差を与えた際に、Throughput/Retr がどう変化するかを再現可能な形で記録しました。

- 目的: 環境（Docker/VM/ホスト直結など）や設定条件（MTU、replay_window等）の違いが、iperf3の ThroughputとRetrに与える影響を定量比較する。
- 観測: ある条件では Retr が多発し、スループットが大幅に低下する一方、条件を変えると Retr が減少し性能が改善することを確認する。

## Requirements
本実験は以下の環境で動作確認を行いました。

- **Hardware:** 10Gbps Ethernet (直結環境)
- **OS:** Ubuntu 22.04 LTS / FreeBSD
- **Container Runtime:** Docker Engine [29.1.3]
- **VPN Software:** strongSwan [6.0.3]
- **Benchmark Tool:** iperf3
- **Network Tools:** iproute2 (ss, ip), ethtool, tcpdump
