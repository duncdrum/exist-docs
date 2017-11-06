xquery version "3.1";

module namespace app="http://exist-db.org/apps/docs/templates";

import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";


declare
  %templates:wrap
  function app:head($node as node(), $model as map(*)) as element(header){

    <header class="header text-center">
        <div class="container">
          <div class="branding">
            <h1 class="logo">
              <img src="resources/images/existdb-logo.png" alt="exist-db" style="height:1em"/>
              <span class="text-bold">Documentation</span>
            </h1>
          </div>
          (: //branding :)

          <div class="tagline">
            <p>Open source native XML database</p>
          </div>
          (: //tagline :)
          {
          let $id := data($node/ancestor::body//div[@role="main"]/@id)

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
            <div class="hip-chat cta-container">
              <a class="btn btn-primary btn-xs" href="https://www.hipchat.com/invite/300223/6ea0341b23fa1cf8390a23592b4b2c39">
                <i class="fa fa-comments-o" aria-hidden="true"/> Hip Chat</a>
            </div>
          </div>
          (: //social-container :)
        )
            else (<ol class="breadcrumb">
              <li>
                  <a href="index.html">Home</a>
              </li>
              <li class="active">{$id}</li>
          </ol>)
        }
        </div>
        (: //container :)
      </header>

};
