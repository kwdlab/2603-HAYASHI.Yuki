# 2603-HAYASHI.Yuki
2026年3月卒業  林佑樹

## Overview
本リポジトリは、10Gbps級ネットワーク環境において、Dockerコンテナ上でIPsec（strongSwan / Linux XFRM）を利用した際に観測される性能変化を、実測データと再現用スクリプトとして整理した卒業研究の成果物です。

Docker（veth/bridge 経路・VM・ホスト直結など実行環境を変えながらiperf3を繰り返し実行し、Throughput・Retr（TCP再送）を同一形式で記録することで、環境差によるスループット低下と再送増加の傾向を定量的に比較できるようにしています。

加えて、MTU拡張（例:1500→64000）やreplay_windowの調整など設定条件を変更した場合の効果も同じ指標で検証し、性能劣化が顕在化する条件と改善が見込める条件を、後から追試しやすい形でまとめています。

## Description
Dockerコンテナ環境におけるIPsec（strongSwan/XFRM）の適用が、通信性能に与える影響をiperf3の計測結果（Throughput/Retr)を中心に整理した実験データ集です。10Gbps環境を前提に、Docker（veth/bridge・VM・ホスト直など、実行環境の違いによってスループット低下やTCP再送（Retr）の増加がどの程度発生するかを比較し、性能劣化が特定の経路・条件で顕著になることを示します。さらに、MTU拡張（例:1500→64000）など設定差を与えた際に、Throughput/Retr がどう変化するかを再現可能な形で記録しました。

- 目的: 環境（Docker/VM/ホスト直結など）や設定条件（MTU、replay_window等）の違いが、iperf3の ThroughputとRetrに与える影響を定量比較する。
- 観測: ある条件では Retr が多発し、スループットが大幅に低下する一方、条件を変えると Retr が減少し性能が改善することを確認する。

## Requirements
本実験は以下の環境で動作確認を行いました。

- **OS:** Ubuntu 22.04 LTS / FreeBSD
- **Container Runtime:** Docker Engine [29.1.3]
- **VPN Software:** strongSwan [6.0.3]
- **Benchmark Tool:** iperf3

## Author
- 林 佑樹

## License
MIT
