# 2603-HAYASHI.Yuki
2026年3月卒業  林佑樹

## Overview
Dockerなどのコンテナ基盤はクラウドで広く使われていますが、Dockerのveth/bridge経路でIPsec（Linux XFRM)を適用すると、TCP再送が増えてスループットが大きく低下する場合があります。さらに、暗号化・認証を行わない ESP=null でも同様の低下が起きることから、ボトルネックは暗号処理そのものではなくXFRM 経路と仮想NIC経路の組合せにある可能性が高い、という問題意識に基づいています。 ￼
本リポジトリは、Docker環境と実機間通信を比較しつつ、MTUとreplay_windowの影響を実測して、性能低下の要因整理と改善の方向性をまとめたものです。 

## Description
IPsec構築にはstrongSwanを用い、鍵交換・SA 管理は strongSwan、ESPのパケット処理はOSカーネルのIPsecスタックで行われます。評価はDocker（同一ホスト上コンテナ間でveth/bridgeを経由と実機間（10Gbps直結)を中心に実施しています。 ￼

測定はiperf3でスループットと TCP再送回数を取得し、受信側ではss -tiから rcv_ooopackなどの統計も観測しました。 ￼
結果として、Docker 環境では IPsec なしで約 28Gbps 出る一方、IPsec 適用時は ESP=nullでも1Gbps未満まで低下し、数千回規模のTCP再送とrcv_ooopackが同時に観測されました。 ￼

一方でMTUを64000 に拡張すると再送が大幅に減少し、暗号化ありで6.04Gbps、ESP=nullで10.13Gbpsまで回復するなど、改善効果が確認できました。 ￼
またreplay_window の調整は再送の緩和に寄与する一方、スループット改善はMTU拡張の効果が支配的でした。 ￼
実機環境ではDockerほど極端な再送増加は見られず、性能低下が顕在化する条件としてDocker特有のveth/bridge 経路が関与している可能性が示唆されます。 ￼

加えて、100Mbps環境のOS比較ではスループットは同程度でも再送回数にばらつきが見られたため、OS実装差は再送の出方には影響し得る一方で、本研究の主要な現象（Docker 環境での極端な性能劣化)はOS差のみでは説明できない、という結論に繋げています。

## Requirements
本実験は以下の環境で動作確認を行いました。

- **OS:** Ubuntu 22.04 LTS / FreeBSD
- **Container Runtime:** Docker Engine [29.1.3]
- **VPN Software:** strongSwan [6.0.3]
- **Benchmark Tool:** iperf3

## Author
- 林 佑樹

## References
- strongSwan: https://www.strongswan.org/
- Linux XFRM/IPsec（ドキュメント）: https://origin.kernel.org/doc/html/latest/networking/xfrm/xfrm_device.html

## License
MIT
