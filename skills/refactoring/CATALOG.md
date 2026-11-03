# Refactoring catalog

臭い（code smell）から引いて、使うリファクタリングとその逆向きのものを見る。名前は英語の正式名で書き、計画やコミットでもその名前を使う。

ほとんどのリファクタリングには逆向きがあり、正解は1つではない。どちらに動かすかは、次の2つの基準で決める。

- **変わる理由が同じか**：同じなら1か所に集め、違うなら分ける。
- **知識と依存を誰に持たせるか**：クライアントが知らなくていいことは隠す。依存の向きは一方通行にする。

逆向きがあるので、やりすぎても戻せる。分けすぎたら、Inline Class、Collapse Hierarchy、Replace Command with Function で戻す。

## Mysterious Name

- Change Function Declaration / Rename Variable / Rename Field
- 名前はやり方（How）ではなく、やること（What）を表す。ドメインの言葉に合わせる。
- いい名前が付けられないのは、概念がまだ分かっていない兆候。
- 否定形の名前は、否定して使うと二重否定になる。肯定形にして、呼び出し側で否定する。

## Long Function

- Extract Function ⇔ Inline Function：その関数を挟むことが役に立っているかで決める。本体が名前と同じくらい明快なら、インライン化する。分け方がおかしいときは、一度全部インライン化して抽出し直す。ただし、複数の呼び出し元が同じルールを共有しているならインライン化しない（コピーが散らばり、直し漏れが出る）。名前が悪いだけなら名前を変える。
- Extract Variable ⇔ Inline Variable
- Replace Temp with Query：計算に名前を付けて、抽出しやすくする。置き換えてよいのは、何度呼んでも同じ結果になる値だけ。ループの途中経過や、ある時点の値を取っておく変数は一時変数のままにする。
- Slide Statements：関係のある文を近くに集める。抽出の準備になる。越える文が、動かす文の参照するものを変更していないか、動かす文が変更するものを参照していないかを確かめる。

## Divergent Change（1つのものが、2つの理由で変わる）

- Split Phase：中間データ構造を挟んで、前半と後半に分ける。各フェーズに必要なものがシグネチャで分かるようになる。
- Split Loop（Loops の臭い）：計算量は変わらないので、遅ければ測ってからまとめ直す。分けたループをまとめるのは簡単だが、絡み合ったループを分けるのは難しい。関数名に `And` が入っていたら、この兆候。
- Split Variable：1つの変数を2つの意味で使い回さない。累積用の変数（`result += ...`）は1つの意味なので分けない。
- Separate Query from Modifier：値を返す関数は副作用を持たない。更新から問い合わせを呼ぶ、一方通行にする。
- Extract Class ⇔ Inline Class：独立した概念（自分のルールを持つもの）があれば分け、ただの属性ならまとめる。
- Decompose Conditional ⇔ Consolidate Conditional Expression：基準は同じ「変わる理由が同じか」。

## Shotgun Surgery / Duplicated Code（1つの変更が、あちこちに散らばる）

- Combine Functions into Class / Combine Functions into Transform：同じデータを使う計算を1か所に集める。元のデータがあとで変わるならメソッドにし（呼ぶたびに計算する）、計算済みの値をデータとして渡したいなら変換にする（一度だけ計算する）。
- Replace Inline Code with Function Call：同じ意味のときだけ置き換える。たまたま同じ形のコードなら置き換えない。
- Move Statements into Function ⇔ Move Statements to Callers：いつも一緒に実行される文は中に入れ、呼び出し元ごとに違う文は外に出す。関数の境界は使われ方が変わるとずれる。フラグ引数を足して逃げない。
- Replace Derived Variable with Query：計算できる値は保存しない。
- Pull Up Method / Pull Up Field / Extract Superclass（Refused Bequest の節も見る）

## Feature Envy（ほかの型のデータばかり使っている）

- Move Function：関数を、よく使うデータの近くに動かす。持ち主の種類を聞き出して分岐しているなら、その種類の側に移す。移動先が持たない状態は引数で渡す。オブジェクトごと渡すと依存が循環しやすい。
- Move Field：データを、それを持つべき型に動かす。

## Data Clumps / Primitive Obsession

- Introduce Parameter Object：引数をまとめる箱ではなく、新しい概念に名前を付けるためのもの。どれか1つを消したら残りが意味をなさないか、自然な名前が付くか（`XxxParams` しか浮かばないなら、ただの箱）を確かめる。本当の価値は、まとめた型に振る舞いが寄ってくること（`Range.Contains`）。
- Replace Primitive with Object：値の意味（順序、比較のしかた、表示）を型に持たせる。決まった値しか作れないようにする。
- Change Reference to Value ⇔ Change Value to Reference：「同じ中身なら同じもの」は値にする（作ったら変えず、変えたいときは差し替える）。「中身が変わっても同じもの」は参照にする（リポジトリから同じ1つを取ってくる）。

## Global Data / Mutable Data / Message Chains / Middle Man / Insider Trading

隠すのは、データの形、コレクションの中身と変わり方、値の意味、オブジェクト同士のつながり。

カプセル化する価値があるのは、書き換えに守るべきルールがある、持ち方を変える可能性がある、中身を書き換えられる参照（マップ、スライス、ポインタ）を外に漏らしたくない、のどれかのときだけ。書き換えないデータや、入出力のためのデータ（DTO、設定）は、レコードのままでよい。

隠す道具は次の2つを組み合わせる。

- 裏口をふさぐ：コピーを返す。中身を書き換えられる参照を返さない。
- 正面玄関を作る：`AddCourse` や `Manager()` のように、変えるときも聞くときも持ち主を通す。

リファクタリング
- Encapsulate Variable / Encapsulate Record / Encapsulate Collection
- Hide Delegate ⇔ Remove Middle Man：クライアントが中の型の機能を1つ2つしか使わないなら隠す。中の型を独立した概念としていろいろ使うなら、直接使わせる。
- Remove Setting Method：変えてはいけない値には setter を置かない。作るときに決める。
- Global Data：Replace Query with Parameter で、引数として渡す形にする。最後はプログラムの入口で作って渡す形になる。手の届かない呼び出し元があるなら、まず Encapsulate Variable で書き換える場所を1か所に集める。

## Repeated Switches / 意図が読めない条件分岐

- Decompose Conditional：条件と、分岐ごとの処理に名前を付ける。
- Consolidate Conditional Expression：同じ結果になる条件を1つにまとめ、名前を付ける。条件が本当に独立したチェック（ほかでも使う、別の規定が決めている）なら、まとめずに条件ごとに名前を付けて組み合わせる。
- Replace Nested Conditional with Guard Clauses：例外的な場合は先に抜け、本筋を入れ子の外に出す。
- Replace Conditional with Polymorphism：判定は、作るとき（ファクトリ）の1か所だけにする。そのあとは型が答えを覚えている。種類を足すのは楽になるが、振る舞いを足すと全部の型を直すことになる。`switch` とポリモーフィズムは閉じている向きが逆なので、どちらの変更が多いかで選ぶ。
- Introduce Special Case（Null Object）：既定値で済むなら場合分けを消す。既定値が使う側ごとに違うなら、判定は使う側に残す。
- Introduce Assertion：コメントにしかない前提を、コードで確かめる。

## Long Parameter List / API の形が合っていない

- Parameterize Function ⇔ Remove Flag Argument：値だけが違うなら引数にしてまとめる。引数で処理を切り替えているなら関数を分ける。ただし、呼び出し側がフラグを変数で持っているなら、フラグを受け取る関数を残してよい（消すと、呼び出し側に毎回 `if` を書かせることになる）。
- Preserve Whole Object ⇔ 値に分けて渡す：呼ばれる側が、その型を扱う立場にあるかで決める。全体を渡すと呼び出しは楽になるが、使わない部分にも依存する。
- Replace Parameter with Query ⇔ Replace Query with Parameter：呼ばれる側が材料を持っているなら、自分で求める。持っていない（グローバル、外の世界）なら、引数で受け取る。
- Replace Function with Command ⇔ Replace Command with Function：途中の状態を多く共有するならコマンドにする。フィールドにするのは途中の状態だけで、答えはローカル変数に残す。作ってすぐ1回実行するだけなら関数に戻す。
- Replace Constructor with Factory Function：作り方に、目的を表す名前を付ける。クライアントは具体的な型やタイプコードを知らずに済む。

## Refused Bequest / 継承の階層が合っていない

- Pull Up Method / Pull Up Field / Pull Up Constructor Body ⇔ Push Down Method / Push Down Field：全員に意味があるなら上に、一部にしか意味がないなら下に。
- Replace Type Code with Subclasses ⇔ Remove Subclass：違いが値だけならデータ（定数、フィールド）で表す。違いが振る舞いなら型で表す。
- Collapse Hierarchy：親と子の違いがなくなったら1つにする。まとめると「どちらだったか」の情報が消えるので、必要ならフィールドで残す。
- Replace Subclass with Delegate / Replace Superclass with Delegate：「〜は〜の一種」（is-a）が成り立たないなら継承しない。親のメソッドの一部が子で意味をなさないときも同じ。委譲先は後から付け替えられる。委譲先からホストを呼ぶと呼び合いになりやすいので、ホストが計算した値を引数で渡す。

## Speculative Generality / Dead Code

- Remove Dead Code：使われていないコードも、読む人に「何のためにあるのか」を考えさせる。眠っているバグも抱えている。コメントアウトしたコードも消す（履歴から取り出せる）。公開 API は、いきなり消さずに非推奨にしてから消す。

## 呼び出し元の直し方

呼び出し元が同じリポジトリにあるなら、宣言と呼び出し元をまとめて1ステップで直す。ステップを小さくするのは、直す手間を減らすためではなく、差分を読んで確かめられる大きさにするため。

段階を踏むのは、一度に直せない呼び出し元があるときだけ。

- **公開 API、ほかのリポジトリのコード**：新しいものを足し、古いものは非推奨にして残す。古いものを消すのは、利用者が移ってから。
- **保存済みのデータ、通信の形式**（JSON のフィールド名、DB のカラム、設定ファイル）：新旧の両方を読めるようにしてから移す。古い形のデータは、書き換えるまで残っている。

## 計画の外に置くもの

- 散らかっていても、次の変更で触らない場所。
- 振る舞いを変えないとできないこと。それは adding function の帽子の仕事になる。
- 性能のための書き換え。読みやすさを先にし、遅ければ測ってから直す。
