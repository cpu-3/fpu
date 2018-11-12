finv2とfsqrtについて。

ともに順序回路で記述されており、ステージ数は3になっています。

finv2は仮数部上位10bit,fsqrtは指数部の最下位bitと仮数部上位9bitでblock ramを引いて、定数項と傾きを得て線形近似をしてyを求めています。

block ramはhoge.binで初期化してあり、fhoge.svでそれを参照しています。

指数部を0に固定して全仮数をテストした結果がdiff.txtに書いてあります。
