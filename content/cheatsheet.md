チートシート
meta-author: 
meta-tags: 
meta-date: 



                <h1>チートシート</h1>
                <div class="row content-block">
                    <div class="col-md-2">
                        <h4>CONTEXTS</h4>
                        <ul>
                            <li>void</li>
                            <li>scalar</li>
                            <li>listr</li>
                        </ul>
                    </div>
                    <div class="col-md-2">
                        <h4>シジル</h4>
                        <ul>
                            <li>$scalar</li>
                            <li>@array </li>
                            <li>%hash  </li>
                            <li>&amp;sub</li>
                            <li>*glob  </li>
                        </ul>
                    </div>
                    <div class="col-md-3">
                        <h4>配列</h4>
                        <ul>
                            <li>全部: @array</li>
                            <li>スライス: @array[0,2]</li>
                            <li>要素: $array[0]</li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h4>ハッシュ</h4>
                        <ul>
                            <li>全部: %hash</li>
                            <li>スライス: @hash{'a', 'b'}</li>
                            <li>要素: $hash{'a'}</li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <h4>スカラ値</h4>
                        <ul>
                            <li>数字</li>
                            <li>文字列</li>
                            <li>リファレンス</li>
                            <li>グロブ</li>
                            <li>undef</li>
                        </ul>
                    </div>
                </div>
                <div class="row content-block">
                    <h4>リファレンス</h4>
                    <div class="col-md-4">
                        <pre>
\     リファレンス         
$@%&amp;* デリファレンス
[]    配列リファレンス
{}    ハッシュリファレンス
\()   リファレンスリスト</pre>
                    </div>
                    <div class="col-md-6">
                        <pre>
$$foo[1]       aka $foo->[1]
$$foo{bar}     aka $foo->{bar}
${$$foo[1]}[2] aka $foo->[1]->[2]
${$$foo[1]}[2] aka $foo->[1][2]</pre>
                    </div>
                </div>
                <div class="row content-block">
                    <div class="col-md-4">
                    <h4>演算子優先順位</h4>
                    <pre>
->                    
++ --                 
**                    
! ~ \ u+ u-           
=~ !~                 
* / % x               
+ - .                 
<< >>                 
named uops            
< > <= >= lt gt le ge 
== != <=> eq ne cmp   
&
| ^                   
&&                    
||                    
.. ...                
?:                    
= += -= *= etc.       
, =>                  
list ops              
not                   
and                   
or xor                </pre>
                    </div>
                    <div class="col-md-4">
                    <h4>数値    と 文字列</h4>
                    <pre>
=          =          
+          .          
== !=      eq ne      
< > <= >=  lt gt le ge
<=>        cmp</pre>
                    </div>
                    <div class="col-md-6">
                    <h4>文法</h4>
                    <pre>
for    (LIST) { }, for (a;b;c) { }
while  ( ) { }, until ( ) { }
if     ( ) { } elsif ( ) { } else { }
unless ( ) { } elsif ( ) { } else { }
for equals foreach (ALWAYS)</pre>
                    </div>
                </div>
                <div class="row content-block">
                    <div class="col-md-5">
                    <h4>正規表現マッチャ</h4>
                    <pre>
^     string begin         
$     str. end (before \n) 
+     one or more          
*     zero or more         
?     zero or one          
{3,7} repeat in range
()    capture              
(?:)  no capture           
[]    character class      
|     alternation</pre>
                    </div>
                    <div class="col-md-5">
                    <h4>正規表現モディファイヤ</h4>
                    <pre>
/i case insens.
/m line based ^$
/s . includes \n
/x ign. wh.space
/g global</pre>
                    </div>
                    <div class="col-md-5">
                    <h4>正規表現文字クラス</h4>
                    <pre>
.  == [^\n]
\s == [\x20\f\t\r\n]
\w == [A-Za-z0-9_]</pre>
                    </div>
                </div>

            </section>
            <section>
                <h1>組み込み関数</h1>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>文字列</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/chomp">chomp</a>
                        
                        <a href="http://perldoc.jp/func/chop">chop</a>
                        
                        <a href="http://perldoc.jp/func/chr">chr</a>
                        
                        <a href="http://perldoc.jp/func/crypt">crypt</a>
                        
                        <a href="http://perldoc.jp/func/fc">fc</a>
                        
                        <a href="http://perldoc.jp/func/hex">hex</a>
                        
                        <a href="http://perldoc.jp/func/index">index</a>
                        
                        <a href="http://perldoc.jp/func/lc">lc</a>
                        
                        <a href="http://perldoc.jp/func/lcfirst">lcfirst</a>
                        
                        <a href="http://perldoc.jp/func/length">length</a>
                        
                        <a href="http://perldoc.jp/func/oct">oct</a>
                        
                        <a href="http://perldoc.jp/func/ord">ord</a>
                        
                        <a href="http://perldoc.jp/func/pack">pack</a>
                        
                        <a href="http://perldoc.jp/func/q">q/STRING/</a>
                        
                        <a href="http://perldoc.jp/func/qq">qq/STRING/</a>
                        
                        <a href="http://perldoc.jp/func/reverse">reverse</a>
                        
                        <a href="http://perldoc.jp/func/rindex">rindex</a>
                        
                        <a href="http://perldoc.jp/func/sprintf">sprintf</a>
                        
                        <a href="http://perldoc.jp/func/substr">substr</a>
                        
                        <a href="http://perldoc.jp/func/tr">tr///</a>
                        
                        <a href="http://perldoc.jp/func/uc">uc</a>
                        
                        <a href="http://perldoc.jp/func/ucfirst">ucfirst</a>
                        
                        <a href="http://perldoc.jp/func/y">y///</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>正規表現</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/m">m//</a>
                        
                        <a href="http://perldoc.jp/func/pos">pos</a>
                        
                        <a href="http://perldoc.jp/func/qr">qr/STRING/</a>
                        
                        <a href="http://perldoc.jp/func/quotemeta">quotemeta</a>
                        
                        <a href="http://perldoc.jp/func/s">s///</a>
                        
                        <a href="http://perldoc.jp/func/split">split</a>
                        
                        <a href="http://perldoc.jp/func/study">study</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>数学</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/abs">abs</a>
                        
                        <a href="http://perldoc.jp/func/atan2">atan2</a>
                        
                        <a href="http://perldoc.jp/func/cos">cos</a>
                        
                        <a href="http://perldoc.jp/func/exp">exp</a>
                        
                        <a href="http://perldoc.jp/func/hex">hex</a>
                        
                        <a href="http://perldoc.jp/func/int">int</a>
                        
                        <a href="http://perldoc.jp/func/log">log</a>
                        
                        <a href="http://perldoc.jp/func/oct">oct</a>
                        
                        <a href="http://perldoc.jp/func/rand">rand</a>
                        
                        <a href="http://perldoc.jp/func/sin">sin</a>
                        
                        <a href="http://perldoc.jp/func/sqrt">sqrt</a>
                        
                        <a href="http://perldoc.jp/func/srand">srand</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>配列</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/each">each</a>
                        
                        <a href="http://perldoc.jp/func/keys">keys</a>
                        
                        <a href="http://perldoc.jp/func/pop">pop</a>
                        
                        <a href="http://perldoc.jp/func/push">push</a>
                        
                        <a href="http://perldoc.jp/func/shift">shift</a>
                        
                        <a href="http://perldoc.jp/func/splice">splice</a>
                        
                        <a href="http://perldoc.jp/func/unshift">unshift</a>
                        
                        <a href="http://perldoc.jp/func/values">values</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>リスト</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/grep">grep</a>
                        
                        <a href="http://perldoc.jp/func/join">join</a>
                        
                        <a href="http://perldoc.jp/func/map">map</a>
                        
                        <a href="http://perldoc.jp/func/qw">qw/STRING/</a>
                        
                        <a href="http://perldoc.jp/func/reverse">reverse</a>
                        
                        <a href="http://perldoc.jp/func/sort">sort</a>
                        
                        <a href="http://perldoc.jp/func/unpack">unpack</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>ハッシュ</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/delete">delete</a>
                        
                        <a href="http://perldoc.jp/func/each">each</a>
                        
                        <a href="http://perldoc.jp/func/exists">exists</a>
                        
                        <a href="http://perldoc.jp/func/keys">keys</a>
                        
                        <a href="http://perldoc.jp/func/values">values</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>入出力</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/binmode">binmode</a>
                        
                        <a href="http://perldoc.jp/func/close">close</a>
                        
                        <a href="http://perldoc.jp/func/closedir">closedir</a>
                        
                        <a href="http://perldoc.jp/func/dbmclose">dbmclose</a>
                        
                        <a href="http://perldoc.jp/func/dbmopen">dbmopen</a>
                        
                        <a href="http://perldoc.jp/func/die">die</a>
                        
                        <a href="http://perldoc.jp/func/eof">eof</a>
                        
                        <a href="http://perldoc.jp/func/fileno">fileno</a>
                        
                        <a href="http://perldoc.jp/func/flock">flock</a>
                        
                        <a href="http://perldoc.jp/func/format">format</a>
                        
                        <a href="http://perldoc.jp/func/getc">getc</a>
                        
                        <a href="http://perldoc.jp/func/print">print</a>
                        
                        <a href="http://perldoc.jp/func/printf">printf</a>
                        
                        <a href="http://perldoc.jp/func/read">read</a>
                        
                        <a href="http://perldoc.jp/func/readdir">readdir</a>
                        
                        <a href="http://perldoc.jp/func/readline">readline</a>
                        
                        <a href="http://perldoc.jp/func/rewinddir">rewinddir</a>
                        
                        <a href="http://perldoc.jp/func/say">say</a>
                        
                        <a href="http://perldoc.jp/func/seek">seek</a>
                        
                        <a href="http://perldoc.jp/func/seekdir">seekdir</a>
                        
                        <a href="http://perldoc.jp/func/select">select</a>
                        
                        <a href="http://perldoc.jp/func/syscall">syscall</a>
                        
                        <a href="http://perldoc.jp/func/sysread">sysread</a>
                        
                        <a href="http://perldoc.jp/func/sysseek">sysseek</a>
                        
                        <a href="http://perldoc.jp/func/syswrite">syswrite</a>
                        
                        <a href="http://perldoc.jp/func/tell">tell</a>
                        
                        <a href="http://perldoc.jp/func/telldir">telldir</a>
                        
                        <a href="http://perldoc.jp/func/truncate">truncate</a>
                        
                        <a href="http://perldoc.jp/func/warn">warn</a>
                        
                        <a href="http://perldoc.jp/func/write">write</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>バイナリ</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/pack">pack</a>
                        
                        <a href="http://perldoc.jp/func/read">read</a>
                        
                        <a href="http://perldoc.jp/func/syscall">syscall</a>
                        
                        <a href="http://perldoc.jp/func/sysread">sysread</a>
                        
                        <a href="http://perldoc.jp/func/sysseek">sysseek</a>
                        
                        <a href="http://perldoc.jp/func/syswrite">syswrite</a>
                        
                        <a href="http://perldoc.jp/func/unpack">unpack</a>
                        
                        <a href="http://perldoc.jp/func/vec">vec</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>ファイル</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/-X">-X</a>
                        
                        <a href="http://perldoc.jp/func/chdir">chdir</a>
                        
                        <a href="http://perldoc.jp/func/chmod">chmod</a>
                        
                        <a href="http://perldoc.jp/func/chown">chown</a>
                        
                        <a href="http://perldoc.jp/func/chroot">chroot</a>
                        
                        <a href="http://perldoc.jp/func/fcntl">fcntl</a>
                        
                        <a href="http://perldoc.jp/func/glob">glob</a>
                        
                        <a href="http://perldoc.jp/func/ioctl">ioctl</a>
                        
                        <a href="http://perldoc.jp/func/link">link</a>
                        
                        <a href="http://perldoc.jp/func/lstat">lstat</a>
                        
                        <a href="http://perldoc.jp/func/mkdir">mkdir</a>
                        
                        <a href="http://perldoc.jp/func/open">open</a>
                        
                        <a href="http://perldoc.jp/func/opendir">opendir</a>
                        
                        <a href="http://perldoc.jp/func/readlink">readlink</a>
                        
                        <a href="http://perldoc.jp/func/rename">rename</a>
                        
                        <a href="http://perldoc.jp/func/rmdir">rmdir</a>
                        
                        <a href="http://perldoc.jp/func/stat">stat</a>
                        
                        <a href="http://perldoc.jp/func/symlink">symlink</a>
                        
                        <a href="http://perldoc.jp/func/sysopen">sysopen</a>
                        
                        <a href="http://perldoc.jp/func/umask">umask</a>
                        
                        <a href="http://perldoc.jp/func/unlink">unlink</a>
                        
                        <a href="http://perldoc.jp/func/utime">utime</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>コントロールフロー</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/break">break</a>
                        
                        <a href="http://perldoc.jp/func/caller">caller</a>
                        
                        <a href="http://perldoc.jp/func/continue">continue</a>
                        
                        <a href="http://perldoc.jp/func/die">die</a>
                        
                        <a href="http://perldoc.jp/func/do">do</a>
                        
                        <a href="http://perldoc.jp/func/dump">dump</a>
                        
                        <a href="http://perldoc.jp/func/eval">eval</a>
                        
                        <a href="http://perldoc.jp/func/evalbytes">evalbytes</a>
                        
                        <a href="http://perldoc.jp/func/exit">exit</a>
                        
                        <a href="http://perldoc.jp/func/goto">goto</a>
                        
                        <a href="http://perldoc.jp/func/last">last</a>
                        
                        <a href="http://perldoc.jp/func/next">next</a>
                        
                        <a href="http://perldoc.jp/func/redo">redo</a>
                        
                        <a href="http://perldoc.jp/func/return">return</a>
                        
                        <a href="http://perldoc.jp/func/sub">sub</a>
                        
                        <a href="http://perldoc.jp/func/wantarray">wantarray</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>ネームスペース</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/caller">caller</a>
                        
                        <a href="http://perldoc.jp/func/import">import</a>
                        
                        <a href="http://perldoc.jp/func/local">local</a>
                        
                        <a href="http://perldoc.jp/func/my">my</a>
                        
                        <a href="http://perldoc.jp/func/our">our</a>
                        
                        <a href="http://perldoc.jp/func/package">package</a>
                        
                        <a href="http://perldoc.jp/func/state">state</a>
                        
                        <a href="http://perldoc.jp/func/use">use</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>その他</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/defined">defined</a>
                        
                        <a href="http://perldoc.jp/func/formline">formline</a>
                        
                        <a href="http://perldoc.jp/func/lock">lock</a>
                        
                        <a href="http://perldoc.jp/func/prototype">prototype</a>
                        
                        <a href="http://perldoc.jp/func/reset">reset</a>
                        
                        <a href="http://perldoc.jp/func/scalar">scalar</a>
                        
                        <a href="http://perldoc.jp/func/undef">undef</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>プロセス</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/alarm">alarm</a>
                        
                        <a href="http://perldoc.jp/func/exec">exec</a>
                        
                        <a href="http://perldoc.jp/func/fork">fork</a>
                        
                        <a href="http://perldoc.jp/func/getpgrp">getpgrp</a>
                        
                        <a href="http://perldoc.jp/func/getppid">getppid</a>
                        
                        <a href="http://perldoc.jp/func/getpriority">getpriority</a>
                        
                        <a href="http://perldoc.jp/func/kill">kill</a>
                        
                        <a href="http://perldoc.jp/func/pipe">pipe</a>
                        
                        <a href="http://perldoc.jp/func/qx">qx/STRING/</a>
                        
                        <a href="http://perldoc.jp/func/readpipe">readpipe</a>
                        
                        <a href="http://perldoc.jp/func/setpgrp">setpgrp</a>
                        
                        <a href="http://perldoc.jp/func/setpriority">setpriority</a>
                        
                        <a href="http://perldoc.jp/func/sleep">sleep</a>
                        
                        <a href="http://perldoc.jp/func/system">system</a>
                        
                        <a href="http://perldoc.jp/func/times">times</a>
                        
                        <a href="http://perldoc.jp/func/wait">wait</a>
                        
                        <a href="http://perldoc.jp/func/waitpid">waitpid</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>モジュール</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/do">do</a>
                        
                        <a href="http://perldoc.jp/func/import">import</a>
                        
                        <a href="http://perldoc.jp/func/no">no</a>
                        
                        <a href="http://perldoc.jp/func/package">package</a>
                        
                        <a href="http://perldoc.jp/func/require">require</a>
                        
                        <a href="http://perldoc.jp/func/use">use</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>オブジェクト</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/bless">bless</a>
                        
                        <a href="http://perldoc.jp/func/dbmclose">dbmclose</a>
                        
                        <a href="http://perldoc.jp/func/dbmopen">dbmopen</a>
                        
                        <a href="http://perldoc.jp/func/package">package</a>
                        
                        <a href="http://perldoc.jp/func/ref">ref</a>
                        
                        <a href="http://perldoc.jp/func/tie">tie</a>
                        
                        <a href="http://perldoc.jp/func/tied">tied</a>
                        
                        <a href="http://perldoc.jp/func/untie">untie</a>
                        
                        <a href="http://perldoc.jp/func/use">use</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>ソケット</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/accept">accept</a>
                        
                        <a href="http://perldoc.jp/func/bind">bind</a>
                        
                        <a href="http://perldoc.jp/func/connect">connect</a>
                        
                        <a href="http://perldoc.jp/func/getpeername">getpeername</a>
                        
                        <a href="http://perldoc.jp/func/getsockname">getsockname</a>
                        
                        <a href="http://perldoc.jp/func/getsockopt">getsockopt</a>
                        
                        <a href="http://perldoc.jp/func/listen">listen</a>
                        
                        <a href="http://perldoc.jp/func/recv">recv</a>
                        
                        <a href="http://perldoc.jp/func/send">send</a>
                        
                        <a href="http://perldoc.jp/func/setsockopt">setsockopt</a>
                        
                        <a href="http://perldoc.jp/func/shutdown">shutdown</a>
                        
                        <a href="http://perldoc.jp/func/socket">socket</a>
                        
                        <a href="http://perldoc.jp/func/socketpair">socketpair</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>SysV</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/msgctl">msgctl</a>
                        
                        <a href="http://perldoc.jp/func/msgget">msgget</a>
                        
                        <a href="http://perldoc.jp/func/msgrcv">msgrcv</a>
                        
                        <a href="http://perldoc.jp/func/msgsnd">msgsnd</a>
                        
                        <a href="http://perldoc.jp/func/semctl">semctl</a>
                        
                        <a href="http://perldoc.jp/func/semget">semget</a>
                        
                        <a href="http://perldoc.jp/func/semop">semop</a>
                        
                        <a href="http://perldoc.jp/func/shmctl">shmctl</a>
                        
                        <a href="http://perldoc.jp/func/shmget">shmget</a>
                        
                        <a href="http://perldoc.jp/func/shmread">shmread</a>
                        
                        <a href="http://perldoc.jp/func/shmwrite">shmwrite</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>ユーザー</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/endgrent">endgrent</a>
                        
                        <a href="http://perldoc.jp/func/endhostent">endhostent</a>
                        
                        <a href="http://perldoc.jp/func/endnetent">endnetent</a>
                        
                        <a href="http://perldoc.jp/func/endpwent">endpwent</a>
                        
                        <a href="http://perldoc.jp/func/getgrent">getgrent</a>
                        
                        <a href="http://perldoc.jp/func/getgrgid">getgrgid</a>
                        
                        <a href="http://perldoc.jp/func/getgrnam">getgrnam</a>
                        
                        <a href="http://perldoc.jp/func/getlogin">getlogin</a>
                        
                        <a href="http://perldoc.jp/func/getpwent">getpwent</a>
                        
                        <a href="http://perldoc.jp/func/getpwnam">getpwnam</a>
                        
                        <a href="http://perldoc.jp/func/getpwuid">getpwuid</a>
                        
                        <a href="http://perldoc.jp/func/setgrent">setgrent</a>
                        
                        <a href="http://perldoc.jp/func/setpwent">setpwent</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>ネットワーク</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/endprotoent">endprotoent</a>
                        
                        <a href="http://perldoc.jp/func/endservent">endservent</a>
                        
                        <a href="http://perldoc.jp/func/gethostbyaddr">gethostbyaddr</a>
                        
                        <a href="http://perldoc.jp/func/gethostbyname">gethostbyname</a>
                        
                        <a href="http://perldoc.jp/func/gethostent">gethostent</a>
                        
                        <a href="http://perldoc.jp/func/getnetbyaddr">getnetbyaddr</a>
                        
                        <a href="http://perldoc.jp/func/getnetbyname">getnetbyname</a>
                        
                        <a href="http://perldoc.jp/func/getnetent">getnetent</a>
                        
                        <a href="http://perldoc.jp/func/getprotobyname">getprotobyname</a>
                        
                        <a href="http://perldoc.jp/func/getprotobynumber">getprotobynumber</a>
                        
                        <a href="http://perldoc.jp/func/getprotoent">getprotoent</a>
                        
                        <a href="http://perldoc.jp/func/getservbyname">getservbyname</a>
                        
                        <a href="http://perldoc.jp/func/getservbyport">getservbyport</a>
                        
                        <a href="http://perldoc.jp/func/getservent">getservent</a>
                        
                        <a href="http://perldoc.jp/func/sethostent">sethostent</a>
                        
                        <a href="http://perldoc.jp/func/setnetent">setnetent</a>
                        
                        <a href="http://perldoc.jp/func/setprotoent">setprotoent</a>
                        
                        <a href="http://perldoc.jp/func/setservent">setservent</a>
                        
                        </p>
                    </div></div>
                </div>
                
                <div class="row content-block">
                    <div class="row content-block"><div class="col-md-12"><h4>時刻</h4>
                        <p>
                        
                        <a href="http://perldoc.jp/func/gmtime">gmtime</a>
                        
                        <a href="http://perldoc.jp/func/localtime">localtime</a>
                        
                        <a href="http://perldoc.jp/func/time">time</a>
                        
                        <a href="http://perldoc.jp/func/times">times</a>
                        
                        </p>
                    </div></div>
                </div>

