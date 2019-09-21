Boss boss;//class初期化(敵)
Tri tri;//class初期化(自機)
Bullet bullet;//class初期化(玉)
Mozi mozi;//class初期化(上からの文字)
PFont font;//class初期化(fontのデータ型指定)
boolean gameover;//class初期化(ゲームオーバークラス)
ArrayList<Mozi> array = new ArrayList<Mozi>();//落ちてくる文字のArrayList作成
ArrayList<String> alh = new ArrayList<String>();//アルファベットのArrayList作成
ArrayList<String> str = new ArrayList<String>();//取ったら文字が使えるようになる文字列strの設定(例としてGUNなど)のArrayList作成
ArrayList<Bullet> gun=new ArrayList<Bullet>();//玉のArrayList作成

int[] ran;//ranというint型の配列を作成
int u=0, d=10, tl=0;//uは文字列を管理しているstrを初期化するときに使う変数,d(画面上の落ちてくる文字数設定),tlはとった文字が武器の文字列と合致しているかを管理する
char t='A';//文字型charのtをAとして初期化
int size;//現在の文字列のサイズを格納するために用いいているが必要ない気がする
int heal=0;//回復処理のための変数(グローバル変数にする意味がわからない)
int ll;//弾丸を撃ったかどうかのフラグで用いている
int ss;//自機が武器を持っているかのフラグ
int yu=0;//弾丸所持数(これもグローバルにするべきではない)
char[] srt;//strをcharの配列に設定
String ring="";//ring(今持っている文字を格納するもの)をString型で初期化

void setup() {//全体のセットアップ
  background(0);//背景シロ
  size(500, 600);//全体のサイズは500×600
  frameRate(60);//フレームレートは60
  noCursor();//カーソルなし
  rectMode(CENTER);//描画モードを中心からに
  tri=new Tri();//tri作成
  boss = new Boss(width/2, 40, 60);//boss作成
  bullet= new Bullet(0, 0, 0, 0, 0, #000000, 0, 0);//bullet作成
  font=createFont("FFScala", 24);//フォントを設定(システムに入っているものを指定できる)
  textFont(font);//使うフォントを指定
  gameover=false;//gameover出ないように初期設定
  srt=new char[26];//srtを26の長さの配列として指定(アルファベットの入る配列らしい) 
  ran=new int[50];//int型配列の作成(長さ50)
  mozi=new Mozi(0, 0, 0, 'a');//文字を白色、aで初期化
  
  for (t='A'; t<='Z'; t++) {//srtのそれぞれにアルファベットを入れていく
    srt[u]=t;
    u++;
  }
  for (int b=0; b<d; b++) {//d(落ちてくる文字数)分、MoziClassでarrayListを作成ranにランダム数を格納し、それを用いてアルファベットを決定する。  
    ran[b]=int(random(0, 26));
    array.add(new Mozi(random(15, width-15), 15.0, random(5, 30), srt[ran[b]]));
  }
  //並べたら武器が使えるようになる文字列----------------------------
  str.add("GUN");
  str.add("M");
  str.add("HEAL");
  //-----------------------------------------------------------
}




class Tri { //自機クラス

  int hp;//HP
  int tx, ty;//自機の場所(x,y)の変数
  Tri() {//自機の初期値設定(インスタンス化)
    hp = 300;
    tx = mouseX;
    ty = mouseY;
  }

  void hit(int mai) { //当たり判定
    hp-=mai;//maiがダメージ量
    background(0, 255, 0);//背景を１フレームだけ黄色に
    if (hp <= 0)//0以下になったらGameOver画面に
      gameover = true;
  }
  //
  void update(int x, int y) { //自機のアップデート関数(体力表示込み)
    //fill(#ffffff);//白色
    textSize(30);
    text(hp, 250, height-15);//体力の値を表示
    tx = x;//自機の位置の修正x
    ty = y;//自機の位置修正y
    noStroke();//線は無し
    fill(#ff0000);
    ellipse(x, y, 20, 20);//自機は丸
    
    if (heal!=0) {//もしもheal(おそらくグローバル変数)が０でなければ 
      hp+=heal;//hpに回復分をプラス
      if(300<hp){//hpが３００以上にはならないように
        hp=300;
      }
      heal=0;//healの初期化
    }
    
  }
}



class Bullet {  //弾丸のクラス
  float bX, bY, br, dX, dY;//左から弾丸の位置x,y、弾丸の半径、弾丸の加速度x,y
  int ma;//弾丸の持ち数を格納する変数
  int tmina=0;//跳ね返りの回数(これをここに入れるなと思う)
  color iro;//弾丸の色
  Bullet(float x, float y, float r, float ldx, float ldy, color op, int mi, int re) {//弾丸の初期化
    bX=x;//弾丸の位置x
    bY=y;//弾丸の位置y
    br=r;//弾丸の半径
    dX=ldx;//xの加速度
    dY=ldy;//yの加速度
    iro=op;//弾丸の色
    ma=mi;//弾丸の攻撃力
    tmina=re;//跳ね返る弾の跳ね返りの回数判定のために変数
  }

  boolean update(int ata) {//弾のアップデート
    bX+=dX;//X軸加速度分を進める
    bY+=dY;//Y軸を加速度分進める
    stroke(iro);//線の色の決定
    noFill();//塗りつぶしは無し
    ellipse(bX, bY, br, br);//半径のbrの円をbX,bYに作成

    if (bX>width||bX<0||bY>height||bY<0) {//表示外に出た場合の処理
      if (ma==5&&(bX>width||bX<0)&&tmina<=3) {//跳ね返りの弾の処理、攻撃力が5でx軸方向に外に出た場合はx軸方向の加速度を逆にして跳ね返す
        dX*=-1;//加速度の逆転
        tmina++;//跳ね返り回数の管理
        return true;//trueを返して弾が消えないようにしている
      } else if (ma==5&&(bY>height||bY<0)&&tmina<=3) {//跳ね返りの弾の処理、攻撃力が5でy軸方向に外に出た場合はy軸方向の加速度を逆にして跳ね返す
        dY*=-1;//加速度の逆転
        tmina++;//跳ね返り回数の管理
        return true;//trueを返して弾が消えないようにしている
      }
      if (tmina==3) {//跳ね返り回数が3回の場合は
        tmina=0;//trueを返さずにtminaを0にする
      }
      return false;//外に出ましたよ(これで球が消される)
    }

    if (dist(bX, bY, tri.tx, tri.ty)<=br/2+2&&ata==1) {//自機との当たり判定(ataはどれに当たったかを調節している)
      tri.hit(ma); //ataが1なので自機へのあたり
      return false;//弾が当たった判定
    }
    if (abs(bX-boss.Bt)<(boss.Bw+br)&&abs(bY-boss.By)<(boss.Bw+br)&&ata==0) {//ボスとの当たり判定(ataが0の場合はハンドガンだからmaは50)
      boss.hit(ma); //ボスへのあたり
      return false;//弾が当たった判定
    }
    if (abs(bX-boss.Bt)<(boss.Bw+br/2)&&abs(bY-boss.By)<(boss.Bw+br/2)&&ata==2) {//ボスとの当たり判定(ataが2なのでマシンガン)
      boss.hit(ma); //ボスへのあたり
      return false;//弾が当たった判定
    }
    return true;//弾が当たっていない
  }
}





class Boss {  //ボスのクラス
  int hp, Bw;//hpは体力,Bwは幅
  float Bx, By, Bt;//BxはボスのX軸方向の位置、Byはy軸方向の位置,Bcxは,Btは位置変化後のボスの位置
  ArrayList barrage;  //弾幕の初期化
  Boss(float x, float y, int w) {//敵の初期化
    Bx=x;//x軸方向の位置の初期化
    By=y;//y軸方向の位置の初期化
    hp=3000;//hpの初期化
    Bw=w;//widthの初期化
    barrage= new ArrayList();//弾幕の初期化
  }
  void hit(int mina) {//ボスに球が当たったばあいの関数
    hp-=mina;//minaが玉の威力その分だけhpを減らす

    if (hp <= 0) //hpが0以下なら
      gameover = true;//gameoverのフラグを立てる
  }

  void bullet_36(float x, float y) {//ボスの弾を作るメソッド
    for (int i=0; i<360; i+=10) {//360度を10度づつ
      float theta=radians(i);//数値を角度にする
      barrage.add(new Bullet(x, y, random(5, 30), cos(theta), sin(theta), #CCFF00, 1, 0));//弾の位置を三角関数にすることで円状の弾丸にする
    }
  }
  void update() {//ボスを更新する

    float wx;//ボスの横移動を管理するwxを宣言する
    fill(#ffffff);//ボスのHP表示の色
    textSize(30);//HPの表示サイズ
    text(hp, 250, 35);//位置
    wx=200.0*sin(radians(frameCount*4));//wxをsinで変化させる

    stroke(0, 0, 255);//線の色
    fill(#ff3399);//ボスの色
    Bt=Bx+wx;//Btに今のボスの位置を格納
    rect(Bt, By, Bw, 40);//ボスは長方形xだけwxで動きを変化する
    if (frameCount % 100==0) bullet_36(Bt, By);//100フレームに一回弾をだす
    if (hp<=2000&&frameCount%60==0) {//HPが2000を下回った場合の追加で出す弾丸、これはフレームカウントが60に一回打つ
      barrage.add(new Bullet(Bt, By, 50, 0, random(5, 10), #FF00CC, 10, 0));//威力が10という強めの弾丸
    }
    if (hp<=1000&&frameCount % 60==0) {//1000以下になった場合に追加で出す弾丸、自機のある場所に弾が飛んでくる

      fire_fast(Bt, By);

      if (frameCount % 50==0) bullet_36(Bt, By);//加えて、フレームカウント%50で追加の炎上の弾を出すようにする
    }
    if (hp<=200&&frameCount%60==0) {//200以下になった場合
      barrage.add(new Bullet(Bt, By, 10, random(5, 10), random(5, 10), #FF00CC, 5, 0));//威力が5の跳ね返る弾をボスが撃ってくるようになる(跳ね返りの処理はbulletClassの中)
    }

    for (int i=barrage.size() -1; i>=0; i--) {//ここで一つ一つの弾を確かめる
      Bullet t=(Bullet)barrage.get(i);//tに弾の状態を入れる
      if (t.update(1)==false) barrage.remove(i);//自機に当たっているかを判定する当たっていたら弾を消す
    }
  }
  void fire_fast(float x, float y) {//hp1000以下のときの変化球を作成する関数、自機のある場所に弾を撃ってくる
    PVector v = get_normalV(mouseX - x, mouseY - y);//ボスの位置と自機の位置の方向をvに格納

    barrage.add(new Bullet(x, y, 10, v.x * 10, v.y * 10, #ff0000, 6, 0));//ベクトル方向に対し弾を打つ
  }
  PVector get_normalV(float vx, float vy) {//ベクトルを手に入れる
    PVector v = new PVector(vx, vy);
    v.normalize();
    return v;
  }
}

class Mozi {//落ちてくる文字のクラス
  float x, y, vy;
  char ch;

  Mozi(float xx, float yy, float vyy, char cha) {//文字の初期化
    x=xx;
    y=yy;
    vy=vyy;
    ch=cha;
  }

  void moziup(int r) {//文字のアップデート
    fill(34);
    textAlign(CENTER);
   
    for (int lr=0; lr<alh.size(); lr++) {//今持っている文字をringに追加する
      ring+=alh.get(lr);//ringに今持っている文字が追加される
    }
    if (switcH()==false) {//switcHがfalse(すなわち、とった文字が武器の種類と合致した場合)

      tl=1;//武器を持っていいフラグがたつ
    } else {
      tl=0;
    }

    fill(#CCFFCC);//落ちてくる文字の色
    textSize(30);//落ちてくる文字のサイズ
    text(ch, x, y);//chが文字内容、x,yはその座標

    y+=vy;//加速度を追加(y軸方向に文字が進む)

    if (dist(mouseX, mouseY, x, y)<25/2||y>height) {//mouseのX,Yの距離が文字の距離と25/2になった場合(当たった場合)または、文字のy軸が高さ以上になった場合(画面外にでた場合)

      if (dist(mouseX, mouseY, x, y)<25/2) {//自機と当たっていた場合

        if (tl!=1&&alh.size()!=20) {//現在、武器を持っている状態ではなく、持っている文字のサイズが20以下の場合

          tl=0;//なぜか武器を持っているかいないかのフラグの初期化
          alh.add(String.valueOf(ch));//落ちている文字を自機が所持する文字列に加える
        }
      }
      y=15;//yを15の位置にする(次のため)
      x=random(15, width-15);//xはランダムに決める
      array.remove(r);//画面外にでた文字を消す
    }


    ring="";//一度ringの初期化
    mozihyouzi(tl);//文字列が武器と同じかどうかの情報をmozihyouziに渡す
  }

  void mozihyouzi(int we) {//文字の表示

    int rp=0;//rp(文字をずらすための調整用変数)を初期化
    if (alh.size()!=0) {//今持っている文字数が0ではない場合
      for (String alh : alh) {//alh分繰り返す
        fill(#ff33cc);//文字の色
        if (we==1) {//武器を持っている状態ならば
          fill(0, 255, 0);//色を変化させる
        }
        
        textSize(25);//サイズが25
        text(alh, 20+15*rp, height-50);//alh(今持っている文字)を表示
        rp++;//文字が重ならないようにずらす
      }
    }
    size=alh.size();//sizeには今持っている文字のサイズを格納
  }
  int first;//first(str内の文字列のどれかに現在保持している文字列のどれが該当するかの確認)を宣言

  boolean switcH() {//持っている銃の変更
    first=0;

    first=str.indexOf(ring);//ringがstrのどこにあるか
    switch(first) {//どのstrないの文字列(つまりはどの武器の文字列と一致しているか)で分岐する

    case 0://0の場合
      gun(first);//gunにfirstを渡す
      ss=1;//武器の所持フラグ管理
      return false;
    case 1:
      gun(first);//同上
      ss=1;//武器の所持フラグ管理
      return false;
    case 2:
      gun(first);//同上
      //ここに所持フラグの管理がないのは回復であるため
      return false;
    default:
      return true;//どの武器にも該当しない場合trueを返す
    }
  }

  void gun(int num) {//銃を管理する関数

    if (num==0&&yu==0) {//num=0それすなわちハンドガンである。
      yu=30;//弾丸所持数=30
    } else if (num==1&&yu==0) {//num=1すなわちマシンガン
      yu=150;//弾丸所持数=150
    }

    if (ll==1) {//自機が弾丸を撃った場合
      if (num==0) {//ハンドガンの場合
        gun.add(new Bullet(mouseX, mouseY, 5, 0, -1, #66FF99, 50, 0));//弾丸の大きさや位置の調整(ハンドガンは一発づつ減る)
        yu--;//弾丸の減少を管理
      } else if (num==1) {//マシンガンの場合
        for (int t=0; t<5; t++) {//5発を時間差で同時に打つため繰り返し
          gun.add(new Bullet(mouseX, mouseY, 5, 0, -6+t, #66FF99, 20, 0));//大きさや位置の調整
          yu--;//弾丸の現象を管理(1発づつ計5個)
        }
      }

      ll=0;//弾丸を撃つフラグを0にする
    }



    if (yu<=30&&num==0) {//ハンドガンで玉数が30以下の場合(弾の発射を管理)

      for (int r=gun.size()-1; r>=0; r--) {//
        Bullet x=gun.get(r);
        if (x.update(0)==false)gun.remove(r);
      }
    } else if (yu<=150&&num==1) {//マシンガンの場合で玉数が150以下の場合(弾の発車を管理)

      for (int r=gun.size()-1; r>=0; r--) {
        Bullet x=gun.get(r);
        if (x.update(2)==false)gun.remove(r);
      }
    }
    fill(#ffff99);//何の銃を持っているかの表示
    textSize(25);//文字のサイズ
    text(yu, width-20, height-50);//位置
    if (num==2) {//numが2の場合は回復
      heal=50;//healを50に設定
      yu=0;//文字の合致のフラグを消す
    }


    if (yu==0) {//yuが0の場合全部を初期化しておく
      alh.clear(); 
      yu=0; 
      ss=0; 
      ring=""; 
      tl=0;
    }
  }
}






void keyPressed() {//キーの判定
  if (key==' '&&alh.size()!=0&&tl!=1) {//スペースを押し、とった文字のサイズが0でなく、銃を打てる情報になっている場合
    alh.remove(size-1);//とった文字列を-1
  } else if (key==ENTER&&alh.size()!=0) {//ENTERを押し、とった文字のサイズが0でなく
    alh.clear();//とった文字を全部削除
    tl=0;//銃の打てる状態を解除
    yu=0;//?
  } else if(key=='a'&&ss==1){//aのキーを入力し、弾丸を打つllを1にする

    ll=1;

  }
}



void draw() {//描画関数
  mozi.switcH();
  if (gameover) {//ゲーム終了、勝ち負けの判定
    textAlign(CENTER);//centerに表示
    if (tri.hp<=0) {//自機のHPが0以下の場合
      fill(255);//白に塗り潰す
      text("YOU LOSE", width/2, height/2);//表示するテキスト
    } else {
      fill(255*sin(frameCount), 255, 255*cos(frameCount));//フレームごとに色を変化させる
      text("YOU WIN!", width/2, height/2);//表示するテキスト
    }
  } else {//ゲームが終了していない場合
    background(0);//背景を黒
    if (array.size()<d) {//画面内の文字数が10以下であった場合
      ran[d]=int(random(0, 26));//ran[d]にランダム数を入れる(なぜ？)
      array.add(new Mozi(random(15, width-15), 15.0, random(5, 6), srt[ran[d]]));//Moziをランダムな場所に生成
    }

    for (int r=array.size()-1; r>=0; r--) {//画面上で落ちている文字の行列サイズ分繰り返す
      Mozi w=array.get(r);//wにrの位置の文字を入れる
      w.moziup(r);//文字のアップデート(当たり判定の見張りなどを行う)
    }
    //int d=1;
    int nowX=mouseX, nowY=mouseY;//今のマウスの位置
    if (nowX<=20)nowX=20; //今のX位置が20以下の場合(おそらく画面外に出ないようにしている)Xを位置20に修正する
    if (height<=nowY+30) nowY=height-30;//こちらも画面外に出ないように位置の修正を行なっている

    tri.update(nowX, nowY);//時期をnowX,nowYで更新
    boss.update();//ボスを更新する
  }
}
