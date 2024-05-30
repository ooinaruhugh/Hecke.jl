import{_ as e,c as a,j as s,a as i,a6 as n,o as t}from"./chunks/framework.BEHfGrEV.js";const V=JSON.parse('{"title":"Conjugacy of integral matrices","description":"","frontmatter":{},"headers":[],"relativePath":"manual/misc/conjugacy.md","filePath":"manual/misc/conjugacy.md","lastUpdated":null}'),l={name:"manual/misc/conjugacy.md"},h=s("h1",{id:"Conjugacy-of-integral-matrices",tabindex:"-1"},[i("Conjugacy of integral matrices "),s("a",{class:"header-anchor",href:"#Conjugacy-of-integral-matrices","aria-label":'Permalink to "Conjugacy of integral matrices {#Conjugacy-of-integral-matrices}"'},"​")],-1),k={style:{"border-width":"1px","border-style":"solid","border-color":"black",padding:"1em","border-radius":"25px"}},p=s("a",{id:"is_GLZ_conjugate-Tuple{ZZMatrix, ZZMatrix}",href:"#is_GLZ_conjugate-Tuple{ZZMatrix, ZZMatrix}"},"#",-1),r=s("b",null,[s("u",null,"is_GLZ_conjugate")],-1),d=s("i",null,"Method",-1),o=n("",1),E={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},g={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"1.593ex",height:"1.532ex",role:"img",focusable:"false",viewBox:"0 -677 704 677","aria-hidden":"true"},Q=s("g",{stroke:"currentColor",fill:"currentColor","stroke-width":"0",transform:"scale(1,-1)"},[s("g",{"data-mml-node":"math"},[s("g",{"data-mml-node":"mi"},[s("path",{"data-c":"1D447",d:"M40 437Q21 437 21 445Q21 450 37 501T71 602L88 651Q93 669 101 677H569H659Q691 677 697 676T704 667Q704 661 687 553T668 444Q668 437 649 437Q640 437 637 437T631 442L629 445Q629 451 635 490T641 551Q641 586 628 604T573 629Q568 630 515 631Q469 631 457 630T439 622Q438 621 368 343T298 60Q298 48 386 46Q418 46 427 45T436 36Q436 31 433 22Q429 4 424 1L422 0Q419 0 415 0Q410 0 363 1T228 2Q99 2 64 0H49Q43 6 43 9T45 27Q49 40 55 46H83H94Q174 46 189 55Q190 56 191 56Q196 59 201 76T241 233Q258 301 269 344Q339 619 339 625Q339 630 310 630H279Q212 630 191 624Q146 614 121 583T67 467Q60 445 57 441T43 437H40Z",style:{"stroke-width":"3"}})])])],-1),c=[Q],y=s("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[s("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[s("mi",null,"T")])],-1),m={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},C={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"-0.186ex"},xmlns:"http://www.w3.org/2000/svg",width:"9.617ex",height:"1.805ex",role:"img",focusable:"false",viewBox:"0 -716 4250.6 798","aria-hidden":"true"},F=n("",1),u=[F],T=s("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[s("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[s("mi",null,"T"),s("mi",null,"A"),s("mo",null,"="),s("mi",null,"B"),s("mi",null,"T")])],-1),_={class:"MathJax",jax:"SVG",style:{direction:"ltr",position:"relative"}},x={style:{overflow:"visible","min-height":"1px","min-width":"1px","vertical-align":"0"},xmlns:"http://www.w3.org/2000/svg",width:"1.593ex",height:"1.532ex",role:"img",focusable:"false",viewBox:"0 -677 704 677","aria-hidden":"true"},w=s("g",{stroke:"currentColor",fill:"currentColor","stroke-width":"0",transform:"scale(1,-1)"},[s("g",{"data-mml-node":"math"},[s("g",{"data-mml-node":"mi"},[s("path",{"data-c":"1D447",d:"M40 437Q21 437 21 445Q21 450 37 501T71 602L88 651Q93 669 101 677H569H659Q691 677 697 676T704 667Q704 661 687 553T668 444Q668 437 649 437Q640 437 637 437T631 442L629 445Q629 451 635 490T641 551Q641 586 628 604T573 629Q568 630 515 631Q469 631 457 630T439 622Q438 621 368 343T298 60Q298 48 386 46Q418 46 427 45T436 36Q436 31 433 22Q429 4 424 1L422 0Q419 0 415 0Q410 0 363 1T228 2Q99 2 64 0H49Q43 6 43 9T45 27Q49 40 55 46H83H94Q174 46 189 55Q190 56 191 56Q196 59 201 76T241 233Q258 301 269 344Q339 619 339 625Q339 630 310 630H279Q212 630 191 624Q146 614 121 583T67 467Q60 445 57 441T43 437H40Z",style:{"stroke-width":"3"}})])])],-1),B=[w],b=s("mjx-assistive-mml",{unselectable:"on",display:"inline",style:{top:"0px",left:"0px",clip:"rect(1px, 1px, 1px, 1px)","-webkit-touch-callout":"none","-webkit-user-select":"none","-khtml-user-select":"none","-moz-user-select":"none","-ms-user-select":"none","user-select":"none",position:"absolute",padding:"1px 0px 0px 0px",border:"0px",display:"block",width:"auto",overflow:"hidden"}},[s("math",{xmlns:"http://www.w3.org/1998/Math/MathML"},[s("mi",null,"T")])],-1),f=n("",2),H=s("br",null,null,-1);function v(j,A,L,M,D,Z){return t(),a("div",null,[h,s("div",k,[p,i(" "),r,i(" — "),d,i(". "),o,s("p",null,[i("Given two integral or rational matrices, determine whether there exists an invertible integral matrix "),s("mjx-container",E,[(t(),a("svg",g,c)),y]),i(" with "),s("mjx-container",m,[(t(),a("svg",C,u)),T]),i(". If true, the second argument is such a matrix "),s("mjx-container",_,[(t(),a("svg",x,B)),b]),i(". Otherwise, the second argument is unspecified.")]),f]),H])}const G=e(l,[["render",v]]);export{V as __pageData,G as default};
