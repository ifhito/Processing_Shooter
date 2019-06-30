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

int count = 0;//countをint型で初期化
int[] ran;//ranというint型の配列を作成
int u=0, d=10, tl=0, it=0;//u,d(画面上の落ちてくる文字数設定),tl,itという変数を作成（なんなんだ？）
char t='A';//文字型charのtをAとして初期化
int eh=0;//
int size;
int ll;

char[] srt;//strをcharの配列に設定
String ring="";//ringをString型で初期化

boolean hante;//おそらく判定用？

void setup() {//全体のセットアップ
  background(0);//背景シロ
  size(500, 600);
  frameRate(60);
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
    hp-=mai;//おそらくmaiがダメージ量
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
  float bX, bY, br, dX, dY;//なんだこれ…(おそらく、左から弾丸の位置x,y、弾丸の半径、弾丸の加速度x,y)
  int ma;//なんだこれ
  int tmina=0;//うーん？？？
  color iro;//おそらくたまの色かな…
  Bullet(float x, float y, float r, float ldx, float ldy, color op, int mi, int re) {//弾丸の初期化
    bX=x;//弾丸の位置x
    bY=y;//弾丸の位置y
    br=r;//弾丸の半径
    dX=ldx;//xの加速度
    dY=ldy;//yの加速度
    iro=op;//弾丸の色
    ma=mi;//弾丸の持ち数
    tmina=re;//?
  }

  boolean update(int ata) {
    bX+=dX;
    bY+=dY;
    stroke(iro);//線の色の決定
    noFill();//塗りつぶしは無し
    ellipse(bX, bY, br, br);//半径のbrの円をbX,bYに作成

    if (bX>width||bX<0||bY>height||bY<0) {//表示外に出た場合の処理
      if (ma==5&&(bX>width||bX<0)&&tmina<=3) {
        dX*=-1;
        tmina++;
        return true;
      } else if (ma==5&&(bY>height||bY<0)&&tmina<=3) {
        dY*=-1;
        tmina++;
        return true;
      }
      if (tmina==3) {
        tmina=0;
      }
      return false;
    }

    if (dist(bX, bY, tri.tx, tri.ty)<=br/2+2&&ata==1) {
      tri.hit(ma); 
      return false;
    }
    if (abs(bX-boss.Bt)<(boss.Bw+br)&&abs(bY-boss.By)<(boss.Bw+br)&&ata==0) {
      boss.hit(ma); 
      return false;
    }
    if (abs(bX-boss.Bt)<(boss.Bw+br/2)&&abs(bY-boss.By)<(boss.Bw+br/2)&&ata==2) {
      boss.hit(ma); 
      return false;
    }
    return true;
  }
}





class Boss {  //teki
  int hp, Bw;
  float Bx, By, Bcx, Bt;
  ArrayList barrage;  //dannmaku
  float wy=0, gw=0;
  Boss(float x, float y, int w) {
    Bx=Bcx=x;
    By=y;
    hp=3000;
    Bw=w;
    barrage= new ArrayList();
  }
  void hit(int mina) {
    hp-=mina;

    if (hp <= 0) 
      gameover = true;
  }

  void bullet_36(float x, float y) { 
    for (int i=0; i<360; i+=10) {
      float theta=radians(i);
      barrage.add(new Bullet(x, y, random(5, 30), cos(theta), sin(theta), #CCFF00, 1, 0));
    }
  }
  void update() {

    float wx;
    fill(#ffffff);
    textSize(30);
    text(hp, 250, 35);
    wx=200.0*sin(radians(frameCount*4));

    Bx=Bcx;
    stroke(0, 0, 255);
    fill(#ff3399);
    rect(Bx+wx, By, Bw, 40);

    Bt=Bx+wx;
    if (frameCount % 100==0) bullet_36(Bt, By);
    if (hp<=2000&&frameCount%60==0) {
      barrage.add(new Bullet(Bx+wx, By, 50, 0, random(5, 10), #FF00CC, 10, 0));
    }
    if (hp<=1000&&frameCount % 60==0) {

      fire_fast(Bt, By);

      if (frameCount % 50==0&&wy%20==0) bullet_36(Bx+wx, By);
    }
    if (hp<=200&&frameCount%60==0) {
      barrage.add(new Bullet(Bx+wx, By, 10, random(5, 10), random(5, 10), #FF00CC, 5, 0));
    }

    for (int i=barrage.size() -1; i>=0; i--) {
      Bullet t=(Bullet)barrage.get(i);
      if (t.update(1)==false) barrage.remove(i);
    }
  }
  void fire_fast(float x, float y) {
    PVector v = get_normalV(mouseX - x, mouseY - y);

    barrage.add(new Bullet(x, y, 10, v.x * 10, v.y * 10, #ff0000, 6, 0));
  }
  PVector get_normalV(float vx, float vy) {
    PVector v = new PVector(vx, vy);
    v.normalize();
    return v;
  }
}




int ss;
int yx=0;
int yu=0;
int heal=0;

class Mozi {
  float x, y, vy;
  char ch;

  Mozi(float xx, float yy, float vyy, char cha) {
    x=xx;
    y=yy;
    vy=vyy;
    ch=cha;
  }

  void moziup(int r) {
    fill(34);
    textAlign(CENTER);
   
    for (int lr=0; lr<alh.size(); lr++) {
      ring+=alh.get(lr);
    }
    if (switcH()==false) {

      tl=1;
    } else {
      tl=0;
    }
    fill(#CCFFCC);
    textSize(30);
    text(ch, x, y);

    y+=vy;
    if (dist(mouseX, mouseY, x, y)<25/2||y>height) {

      if (dist(mouseX, mouseY, x, y)<25/2) {

        if (tl!=1&&alh.size()!=20) {

          tl=0;
          alh.add(String.valueOf(ch));
        }
      }
      y=15;
      x=random(15, width-15);
      array.remove(r);
    }


    ring="";
    mozihyouzi(tl);
  }

  void mozihyouzi(int we) {

    int rp=0;
    if (alh.size()!=0) {
      for (String alh : alh) {
        fill(#ff33cc);
        if (we==1) {
          fill(0, 255, 0);
        }
        
        textSize(25);
        text(alh, 20+15*rp, height-50);
        rp++;
      }
    }
    size=alh.size();
  }
  int first;

  boolean switcH() {
    first=0;

    first=str.indexOf(ring);
    switch(first) {

    case 0:
      gun(first);
      ss=1;
      return false;
    case 1:
      gun(first);
      ss=1;
      return false;
    case 2:
      gun(first);
      return false;
    default:
      return true;
    }
  }

  void gun(int num) {

    if (num==0&&yu==0) {
      yu=30;
    } else if (num==1&&yu==0) {
      yu=150;
    }

    if (ll==1) {
      if (num==0) {
        gun.add(new Bullet(mouseX, mouseY, 5, 0, -1, #66FF99, 50, 0));
        yu--;
      } else if (num==1) {
        for (int t=0; t<5; t++) {
          gun.add(new Bullet(mouseX, mouseY, 5, 0, -6+t, #66FF99, 20, 0));
          yu--;
        }
      }

      ll=0;
    }



    if (yu<=30&&num==0) {

      for (int r=gun.size()-1; r>=0; r--) {
        Bullet x=gun.get(r);
        if (x.update(0)==false)gun.remove(r);
      }
    } else if (yu<=150&&num==1) {

      for (int r=gun.size()-1; r>=0; r--) {
        Bullet x=gun.get(r);
        if (x.update(2)==false)gun.remove(r);
      }
    }
    fill(#ffff99);
    textSize(25);
    text(yu, width-20, height-50);
    if (num==2) {
      heal=50;
      yu=0;
    }


    if (yu==0) {
      alh.clear(); 
      yu=0; 
      ss=0; 
      ring=""; 
      tl=0;
    }
  }
}






void keyPressed() {
  if (key==' '&&alh.size()!=0&&tl!=1) {
    alh.remove(size-1);
  } else if (key==ENTER&&alh.size()!=0) {
    alh.clear();
    tl=0;
    yu=0;
  } else if(key=='a'&&ss==1){

    ll=1;

  }
}



void draw() {
  mozi.switcH();
  if (gameover) {  //katimake
    textAlign(CENTER);
    if (tri.hp<=0) {
      fill(255);
      text("YOU LOSE", width/2, height/2);
    } else {
      fill(255*sin(frameCount), 255, 255*cos(frameCount));
      text("YOU WIN!", width/2, height/2);
    }
  } else {
    background(0);
    if (array.size()<d) {
      ran[d]=int(random(0, 26));
      array.add(new Mozi(random(15, width-15), 15.0, random(5, 6), srt[ran[d]]));
    }
    count+=20;

    for (int r=array.size()-1; r>=0; r--) {
      Mozi w=array.get(r);
      w.moziup(r);
    }
    int d=1;
    int nowX=mouseX, nowY=mouseY;
    if (nowX<=20) { 
      nowX=20; 
      d=0;
    }
    if (height<=nowY+30) nowY=height-30;

    tri.update(nowX, nowY);
    boss.update();
  }
}
