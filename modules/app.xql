xquery version "3.1";

module namespace app="http://exist-db.org/apps/docs/templates";

declare namespace xqdoc="http://www.xqdoc.org/1.0";
import module namespace templates="http://exist-db.org/xquery/templates";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare variable $app:tickets :="https://github.com/duncdrum/exist-docs/issues/new?title=error%20on%20quickstart";
declare variable $app:MD_MODULE_URI := "http://exist-db.org/xquery/markdown";

declare variable $app:MD_HAS_MODULE :=
    try {
        inspect:inspect-module-uri(xs:anyURI($app:MD_MODULE_URI))
    } catch * {
        ()
    };
    
declare variable $app:MD_CONFIG := map {
    "code-block": function($language as xs:string, $code as xs:string) {
        <div class="signature" data-language="{$language}">{$code}</div>
    },
    "heading": function($level as xs:int, $content as xs:string*) {
        element { "h" || 1 + $level } {
            $content
        }
    }
};

(: Placeholder and unfinished :)

declare
  %templates:wrap
function app:body($node as node(), $model as map(*)) {
(: not doing anything right now went with JS instead :)
    switch($node/ancestor::html//div[@role="main"]/@id)
      case 'index' return attribute class {'landing-page'}
    default return attribute class {'body-green'}
};

declare function app:fa-icons($node as node(), $model as map(*)) as element(i){
  switch($node)
    case 'Getting Started with Web Application Development'
      return <i class="icon fa fa-paper-plane"/>
    default return <i class="icon icon_puzzle_alt"/>
};


declare
  %templates:wrap
  function app:promo($node as node(), $model as map(*)) as element(div){
    (: might go if no new use case comes up :)
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

(: live n hot :)

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
          (: there is probably a better way to find this, but it escapes me right now. :)
          let $uri := tokenize(request:get-uri(), '/') 
          let $file := for $token in $uri
            where contains($token, '.')
            return
                substring-before($token, '.')
          return
            if ($file eq "index")
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
                <a href="#">{$file}</a>
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
function app:ticket($node as node(), $model as map(*)) as element(div){
  <div class="content-holder col-md-5 col-sm-6 col-xs-12">
    <div class="content-holder-inner">
      <h4 class="content-title">
        <strong>Found a problem with this page?</strong>
      </h4>
      <p>Please submit an issue so we can improve it.</p>
      <a href="{$app:tickets}" class="btn btn-red btn-cta">
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

(: funcdoc import:)

declare function app:check-dba-user($node as node(), $model as map(*)) {
    let $user := xmldb:get-current-user()
    return
        if (sm:is-dba($user)) then
            $node
        else
            ()
};

declare function app:check-dba-user-and-not-data($node as node(), $model as map(*)) {
    let $data := collection($config:data-root)/xqdoc:xqdoc
    let $user := xmldb:get-current-user()
    return
        if (sm:is-dba($user) and not($data)) then
            element { node-name($node) } {
                $node/@* except $node/@data-template, $node/node()
            }
        else
            ()
};

declare function app:check-dba-user-and-data($node as node(), $model as map(*)) {
    let $data := collection($config:data-root)/xqdoc:xqdoc
    let $user := xmldb:get-current-user()
    return
        if (sm:is-dba($user) and ($data)) then
            element { node-name($node) } {
                $node/@* except $node/@data-template, $node/node()
            }
        else
            ()
};

declare function app:check-not-data($node as node(), $model as map(*)) {
    let $data := collection($config:data-root)/xqdoc:xqdoc
    return
        if (not($data)) then
            $node
        else
            ()
};

declare function app:check-not-dba-user-and-not-data($node as node(), $model as map(*)) {
    let $data := collection($config:data-root)/xqdoc:xqdoc
    let $user := xmldb:get-current-user()
    return
        if (not(sm:is-dba($user)) and not($data)) then
            $node
        else
            ()
};

declare 
    %templates:default("action", "search")
    %templates:default("type", "name")
function app:action($node as node(), $model as map(*), $action as xs:string, $module as xs:string?, 
    $q as xs:string?, $type as xs:string) {
    switch ($action)
        case "browse" return
            app:browse($node, $module)
        case "search" return
            app:search($node, (), $q, $type)
        default return
            ()
};

declare %private function app:browse($node as node(), $module as xs:string?) {
    let $functions := collection($config:data-root)/xqdoc:xqdoc[xqdoc:module/xqdoc:uri = $module]//xqdoc:function
    return
        map { "result" := $functions }
};

declare %private function app:search($node as node(), $module as xs:string?, 
    $q as xs:string?, $type as xs:string) {
    let $functions :=
        switch( $type )
        case "name" return
            collection($config:data-root)/xqdoc:xqdoc//xqdoc:function[ngram:contains(xqdoc:name, $q)]
        case "signature" return
            collection($config:data-root)/xqdoc:xqdoc//xqdoc:function[ngram:contains(xqdoc:signature, $q)]
        case "desc" return
            collection($config:data-root)/xqdoc:xqdoc//xqdoc:function[ngram:contains(xqdoc:comment/xqdoc:description, $q)]
        default return ()
        order by $module/xqdoc:xqdoc/xqdoc:control/xqdoc:location/text(), $module/xqdoc:xqdoc/xqdoc:module/xqdoc:name/text()
    return
        map { "result" := $functions }
};

declare 
    %templates:default("details", "false")
function app:module($node as node(), $model as map(*), $details as xs:boolean) {
    let $functions := $model("result")
    for $module in $functions/ancestor::xqdoc:xqdoc    
    let $uri := $module/xqdoc:module/xqdoc:uri/text()
    let $location := $module/xqdoc:control/xqdoc:location/text()
    let $order := (if ($location) then $location else " " || $uri)
    let $funcsInModule := $module//xqdoc:function intersect $functions
    
    order by $order
    return
        app:print-module($module, $funcsInModule, $details)
};

declare %private function app:print-module($module as element(xqdoc:xqdoc), $functions as element(xqdoc:function)*, 
    $details as xs:boolean) {
    let $location := $module/xqdoc:control/xqdoc:location/text()
    let $uri := $module/xqdoc:module/xqdoc:uri/text()
    let $extDocs := app:get-extended-module-doc($module)[1]
    let $description := $module/xqdoc:module/xqdoc:comment/xqdoc:description/node()
    let $parsed := if (contains($description, '&lt;') or contains($description, '&amp;')) then $description else util:parse("<div>" || replace($description, "\n{2,}", "<br/>") || "</div>")/*/node()
    return
    <div class="module" data-xqdoc="{document-uri(root($module))}">
        <div class="module-head">
            <div class="module-head-inner">
                <div class="row">
                    <div class="col-md-1 hidden-xs">
                        <a href="view.html?uri={$uri}&amp;location={$location}&amp;details=true" 
                            class="module-info-icon"><span class="glyphicon glyphicon-info-sign"/></a>
                    </div>
                    <div class="col-md-11 col-xs-12">
                        <h3><a href="view.html?uri={$uri}&amp;location={$location}&amp;details=true">{ $uri }</a></h3>
                        {
                                if ($location) then
                                    if (starts-with($location, '/db')) then
                                        <h4><a href="../eXide/index.html?open={$location}">{$location}</a></h4>
                                    else
                                        <h4>{$location}</h4>
                                else
                                    ()
                        }
                        <p class="module-description">{ $parsed }</p>
                        {
                            let $metadata := $module/xqdoc:module/xqdoc:comment/(xqdoc:author|xqdoc:version|xqdoc:since)
                            return
                                if (exists($metadata)) then
                                    <table>
                                    {
                                        for $meta in $metadata
                                        return
                                            <tr>
                                                <td>{local-name($meta)}</td>
                                                <td>{$meta/string()}</td>
                                            </tr>
                                    }
                                    </table>
                                else
                                    ()
                        }
                    </div>
                </div>
            </div>
        </div>
        {
            if ($details and exists($extDocs)) then
                <div class="extended">
                    <h1>Overview</h1>
                    { app:parse-markdown($extDocs) }
                </div>
            else
                ()
        }
        <div class="functions">
            {
                if ($details and exists($extDocs)) then
                    <h1>Functions</h1>
                else
                    ()
            }
            {
                for $function in $functions
                order by $function/xqdoc:name
                return
                    app:print-function($function, false())
            }
        </div>
    </div>
};

declare %private function app:print-function($function as element(xqdoc:function), $details as xs:boolean) {
    let $comment := $function/xqdoc:comment
    let $function-name := $function/xqdoc:name
    let $arity := count($function/xqdoc:comment/xqdoc:param)
    let $arity := 
        (: If there are params in the signature, but these are not listed in comment/param, do not state that the number of params is 0. :)
        if ($arity eq 0 and contains($function/xqdoc:signature, '$'))
        then ()
        else ('.' || $arity)
    let $function-identifier := 
        (: If the name has no prefix, use the name as it is. :)
        if (contains($function-name, ':'))
        then (substring-after($function-name, ":") || $arity)
        else ($function-name || $arity)
    let $description := $comment/xqdoc:description/node()
    let $parsed := if (contains($description, '&lt;') or contains($description, '&amp;')) then $description else util:parse("<div>" || replace($description, "\n{2,}", "<br/>") || "</div>")/*/node()
    let $extDocs := app:get-extended-doc($function)[1]
    return
        <div class="function" id="{$function-identifier}">
            <div class="function-head">
                <h4>{$function-name/node()}</h4>
                <div class="signature" data-language="xquery">{ $function/xqdoc:signature/node() }</div>
            </div>
            <div class="function-detail">
                <p class="description">{ $parsed }</p>
                {
                    if (exists($extDocs) and not($details)) then
                        let $module := $function/ancestor::xqdoc:xqdoc
                        let $uri := $module/xqdoc:module/xqdoc:uri/text()
                        let $location := $module/xqdoc:control/xqdoc:location/text()
                        let $arity := count($function/xqdoc:comment/xqdoc:param)
                        let $query := "?" || "uri=" || $uri ||
                            "&amp;function=" || $function-name || "&amp;arity=" || $arity ||
                            (if ($location) then ("&amp;location=" || $location) else "#")
                        return
                            <a href="view.html{$query}" class="extended-docs btn btn-primary">
                                <span class="glyphicon glyphicon-info-sign"></span> Read more</a>
                    else
                        ()
                }
                <dl class="parameters">          
                    {
                        if($comment/xqdoc:param) then 
                            (
                                <dt>Parameters:</dt>,
                                <dd>
                                {
                                    app:print-parameters($comment/xqdoc:param)
                                }
                                </dd>
                            )
                        else 
                            ""
                    }
                    {
                        let $returnValue := $comment/xqdoc:return/node()
                        return
                            if($returnValue) then
                                (
                                    <dt>Returns:</dt>,
                                    <dd>{ $returnValue }</dd>
                                )
                            else
                                ""
                    }
                    {
                        if($comment/xqdoc:deprecated) then 
                            (
                                <dt>Deprecated:</dt>,
                                <dd>{ $comment/xqdoc:deprecated/string() }</dd>
                            )
                        else 
                            ""
                    }
         
                </dl>
                {
                    if ($details and exists($extDocs)) then
                        <div class="extended">
                            <h1>Detailed Description</h1>
                            { app:parse-markdown($extDocs) }
                        </div>
                    else
                        ()
                }
            </div>
        </div>
};

declare %private function app:parse-markdown($path as xs:string) {
    if ($app:MD_HAS_MODULE) then
        let $expr := 
            'import module namespace markdown="http://exist-db.org/xquery/markdown";' ||
            'markdown:parse(util:binary-to-string(util:binary-doc($path)), ($markdown:HTML-CONFIG, $app:MD_CONFIG))'
        return
            util:eval($expr)
    else
        <div class="alert alert-warning">Install markdown parser module via dashboard to display extended documentation.</div>
};

declare %private function app:print-parameters($params as element(xqdoc:param)*) {
    <table>
    {
        (: The data generated by xqdm:scan contains too much white space :)
        $params/normalize-space() !
            <tr>
                <td class="parameter-name">{replace(., "^([^\s]+)\s.*$", "$1")}</td>
                <td>{replace(., "^[^\s]+\s(.*)$", "$1")}</td>
            </tr>
    }
    </table>
};

declare %private function app:get-extended-doc($function as element(xqdoc:function)) {
    let $name := replace($function/xqdoc:name, "([^:]+:)?(.*)$", "$2")
    let $arity := count($function/xqdoc:comment/xqdoc:param)
    let $prefix := $function/ancestor::xqdoc:xqdoc/xqdoc:module/xqdoc:name
    let $prefix := if ($prefix/text()) then $prefix else "fn"
    let $paths := (
        (: Search for file with arity :)
        $config:ext-doc || "/" || $prefix || "/" || $name || "_" || $arity || ".md",
        (: General file without arity :)
        $config:ext-doc || "/" || $prefix || "/" || $name || ".md"
    )
    for $path in $paths
    return
        if (util:binary-doc-available($path)) then
            $path
        else
            ()
};

declare %private function app:get-extended-module-doc($module as element(xqdoc:xqdoc)) {
    let $prefix := $module/xqdoc:module/xqdoc:name
    let $prefix := if ($prefix/text()) then $prefix else "fn"
    let $paths := (
        (: Module description is either "_module.md" or prefix.md :)
        $config:ext-doc || "/" || $prefix || "/_module.md",
        $config:ext-doc || "/" || $prefix || "/" || $prefix || ".md"
    )
    for $path in $paths
    return
        if (util:binary-doc-available($path)) then
            $path
        else
            ()
};

(: ~
 : If eXide is installed, we can load ace locally. If not, download ace
 : from cloudfront.
 :)
declare function app:import-ace($node as node(), $model as map(*)) {
    let $eXideInstalled := doc-available("/db/eXide/repo.xml")
    let $path :=
        if ($eXideInstalled) then
            "../eXide/resources/scripts/ace/"
        else
            "//d1n0x3qji82z53.cloudfront.net/src-min-noconflict/"
    for $script in $node/script
    return
        <script>
        {
            $script/@* except $script/@src,
            attribute src { $path || $script/@src }
        }
        </script>
};

declare 
    %templates:default("w3c", "false")
    %templates:default("extensions", "false")
    %templates:default("appmodules", "false")
function app:showmodules($node as node(), $model as map(*),  $w3c as xs:boolean, $extensions as xs:boolean, $appmodules as xs:boolean) {
    
    for $module in collection($config:data-root)//xqdoc:xqdoc
    
    let $uri := $module/xqdoc:module/xqdoc:uri/text()
    let $location := $module/xqdoc:control/xqdoc:location/text()

    (: path to anchor module :)
    let $query := "?" || "uri=" || $uri || (if ($location) then ("&amp;location=" || $location) else "#")
    
    order by $uri
    return 
        if ( 
            ($w3c and starts-with($uri, 'http://www.w3.org') ) or 
            ($extensions and starts-with($uri, 'http://exist-db.org/xquery') and not(starts-with($location, '/db'))) or
            ($extensions and starts-with($uri, 'http://exist-db.org/') and (empty($location) or starts-with($location, 'java:'))) or
            ($appmodules and starts-with($location, '/db'))
           ) then
            <tr><td><a href="view.html{$query}">{$uri}</a></td><td>{$location}</td></tr> 
        else
            ()
  
        
};


declare 
    %templates:default("uri", "http://www.w3.org/2005/xpath-functions")
    %templates:default("details", "false")
function app:view($node as node(), $model as map(*),  $uri as xs:string, $location as xs:string?, $function as xs:string?,
    $arity as xs:int?, $details as xs:boolean) {
    
    let $modules :=  
        if ($location)  then
            collection($config:data-root)/xqdoc:xqdoc[xqdoc:module/xqdoc:uri eq $uri][xqdoc:control/xqdoc:location eq $location]
        else
            collection($config:data-root)/xqdoc:xqdoc[xqdoc:module/xqdoc:uri eq $uri]
    return
        for $module in $modules
        return
            if ($function) then
                for $xqdocfunction in
                    if (exists($arity)) then
                        $module//xqdoc:function[xqdoc:name eq $function][count(xqdoc:comment/xqdoc:param)=$arity]
                    else
                        $module//xqdoc:function[xqdoc:name eq $function]
                return
                    app:print-function($xqdocfunction, exists($function))
            else
                app:print-module($module, $module//xqdoc:function, $details)
};

(:end func-doc import:)