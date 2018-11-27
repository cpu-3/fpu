ステージ数
fadd2,fmul,finv2,fsqrtすべて2

finv2は仮数部上位10bit,fsqrtは指数部の最下位bitと仮数部上位9bitでblock ramを引いて、定数項と傾きを得て線形近似をしてyを求めています。

block ramはhoge.binで初期化してあり、fhoge.svでそれを参照しています。

指数部を0に固定して全仮数をテストした結果がdiff.txtに書いてあります。



既知のバグ

fsqrt(nan)=+0 or -0
fsqrt(非正規化数)=+0 or -0
