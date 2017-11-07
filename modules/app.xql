xquery version "3.1";

module namespace app="http://exist-db.org/apps/docs/templates";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare
  %templates:wrap
function app:body($node as node(), $model as map(*)) {
(: not doing anything right now went with JS instead :)
    switch($node/ancestor::html//div[@role="main"]/@id)
      case 'index' return attribute class {'landing-page'}
    default return attribute class {'body-green'}
};

declare function app:head($node as node(), $model as map(*)) as element(header){

    <header class="header text-center">
        <div class="container">
          <div class="branding">
            <h1 class="logo">
              <img src="resources/images/existdb-logo.png" alt="exist-db" style="height:1em"/>
              <span class="text-bold"> Documentation</span>
            </h1>
          </div>
          <!-- //banding -->
          <div class="tagline">
            <p>Open source native XML database</p>
          </div>
          <!-- //tag-line -->
          {
          let $id := data($node/ancestor::body//div[@role="main"]/@id)
          (: set title via id + role above docHeader :)
          return
            if ($id eq "index")
            then (<div class="social-container">
            <div class="twitter-tweet">
              <a href="https://twitter.com/share" class="twitter-share-button" data-text="eXist-db open source native XML database" data-via="existdb">Tweet</a>
              <script>
                <![CDATA[! function(d, s, id) {
                  var js, fjs = d.getElementsByTagName(s)[0],
                    p = /^http:/.test(d.location) ? 'http' : 'https';
                  if (!d.getElementById(id)) {
                    js = d.createElement(s);
                    js.id = id;
                    js.src = p + '://platform.twitter.com/widgets.js';
                    fjs.parentNode.insertBefore(js, fjs);
                  }
                }(document, 'script', 'twitter-wjs');]]>
              </script>
            </div>
            <!-- //twitter-tweet -->
            <div class="hip-chat cta-container">
              <a class="btn btn-primary btn-xs" href="https://www.hipchat.com/invite/300223/6ea0341b23fa1cf8390a23592b4b2c39">
                <i class="fa fa-comments-o" aria-hidden="true"/> Hip Chat</a>
            </div>
            <!-- //hip-chat -->
          </div>)
            else (<ol class="breadcrumb">
              <li>
                  <a href="index.html">Home</a>
              </li>
              <li class="active">
                <a href="#">{$id}</a>
              </li>
          </ol>)
        }
        </div>
        <!-- //container -->
      </header>

};

declare function app:foot($node as node(), $model as map(*)) as element(footer){
  <footer class="footer text-center">
    <div class="container">
      <!--/* This template is released under the Creative Commons Attribution 3.0 License. Please keep the attribution link below when using for your own project. Thank you for your support. :) If you'd like to use the template without the attribution, you can check out other license options via our website: themes.3rdwavemedia.com */-->
      <small class="copyright">Designed with <i class="fa fa-heart"/> by <a href="https://themes.3rdwavemedia.com/" target="_blank">Xiaoying Riley</a>. Refactored for <a href="https://exist-db.org">exist-db</a> by <a href="https://github.com/duncdrum">Duncan Paterson</a>.</small>
    </div>
    <!-- //container -->
  </footer>
(:  <!-- //footer -->  :)
};

declare
  %templates:wrap
  function app:promo($node as node(), $model as map(*)) as element(div){
    <div id="promo-block" class="promo-block">
      <div class="container">
        <div class="promo-block-inner">
          <div class="row">
            <div data-template="app:ticket"/>
            <div data-template="app:further-reading"/>
            </div>
            <!-- //row -->
          </div>
          <!-- //promo-inner -->
        </div>
        <!-- //container -->
      </div>
    (:  <!-- //promo-block -->    :)
  };

declare
  %templates:wrap
function app:ticket($node as node(), $model as map(*)) as element(div){
  <div class="content-holder col-md-5 col-sm-6 col-xs-12">
    <div class="content-holder-inner">
      <h4 class="content-title">
        <strong>Found a problem with this page?</strong>
      </h4>
      <p>Please submit an issue so we can improve it.</p>
      <a href="https://github.com/duncdrum/exist-docs/issues/new?title=error%20on%20quickstart" class="btn btn-red btn-cta">
        <i class="fa fa-exclamation-circle"/> Submit Issues</a>
    </div>
    <!-- //content-inner -->
  </div>
  (:<!-- //content-holder -->:)
  };

declare
  %templates:wrap
function app:further-reading($node as node(), $model as map(*)) as element(div){
<div class="content-holder col-md-7 col-sm-6 col-xs-12">
  <div class="content-holder-inner">
    <div class="desc">
      <h4 class="content-title">Further Reading</h4>
      <div class="table-responsive">
        <table class="table">
          <thead>
              <tr>
                  <th>Source</th>
                  <th>Link</th>
              </tr>
          </thead>
          <tbody>
              <tr>
                  <td>
                      <p class="text-primary">XQuery Specs:</p>
                  </td>
                  <td>Some page</td>
              </tr>
              <tr>
                  <td>
                      <p class="text-primary">The book:</p>
                  </td>
                  <td>Some chapter</td>
              </tr>
              <tr>
                  <td>
                      <p class="text-primary">Wikibooks:</p>
                  </td>
                  <td>another link</td>
              </tr>
          </tbody>
        </table>
      </div>
<!-- //table-responsive -->
    </div>
   <!-- //desc -->
  </div>
 <!-- //content-inner --> 
</div>
(:<!-- //content-holder --> :)
};

declare function app:fa-icons($node as node(), $model as map(*)) as element(i){
  switch($node)
    case 'Getting Started with Web Application Development'
      return <i class="icon fa fa-paper-plane"/>
    default return <i class="icon icon_puzzle_alt"/>
};
