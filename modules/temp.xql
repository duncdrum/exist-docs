xquery version "3.0";



import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";
import module namespace templates="http://exist-db.org/xquery/templates" at "templates.xql";
import module namespace dq="http://exist-db.org/xquery/documentation/search" at "search.xql";

(: testbed for docbook transform :)
declare variable $local:INLINE :=
    ("filename", "classname", "methodname", "option", "command", "parameter", "guimenu", "guimenuitem", "guibutton", "function", "envar");

declare variable $local:test := doc($config:data-root || "/" || 'quickstart.xml');
(:~
 : Load a docbook document. If a query was specified, re-run the query on the document
 : to get matches highlighted.
 :)
declare
    %public %templates:default("field", "all")
function local:load($node as node(), $model as map(*), $q as xs:string?, $doc as xs:string?, $field as xs:string) {
    let $path := $config:data-root || "/" || $doc
    return
        if (exists($doc) and doc-available($path)) then
            let $context := doc($path)
            let $data :=
                if ($q) then
                    dq:do-query($context, $q, $field)
                else
                    $context
            return
                map { "doc" := util:expand($data/*, "add-exist-id=all") }
        else
            <p>Document not found: {$path}!</p>
};

(:~
 : Transform the docbook fragment given in $model.
 :)
declare %public function local:to-html($node as node(), $model as map(*)) {
    local:to-html($model("doc"))
};

(:~
 : Generate a table of contents.
 :)
declare %public function local:toc($node as node(), $model as map(*)) as element(ul){
    <ul id="doc-menu" class="nav doc-menu" data-spy="affix">
      {local:print-sections($model("doc")/*/(chapter|section))}
    </ul>
};

declare %public function local:sidebar($chapter as element()) as element(ul){
       
        <ul id="doc-menu" class="nav doc-menu" data-spy="affix">
          {for $section in $chapter//section
          return
            <li>
              <a class="scrollto" 
                href="#{
                    if ($section/@id) 
                    then lower-case(replace($section/@id, '\s', '-')) 
                    else concat("D", lower-case(replace($section/@exist:id, '\s', '-')))}">
                 { $section/title/text() }</a>
            </li>  
            }
        </ul>
};

declare %private function local:print-sections($sections as element()*) {
    for $section in $sections
    let $id := if ($section/@id) 
        then lower-case(replace($section/@id, '\s', '-')) 
        else concat("D", lower-case(replace($section/@exist:id, '\s', '-')))
    

    return
        <li>
          <a class="scrollto" href="#{$id}">{ $section/title/text() }</a>
            { local:print-sections($section/(chapter|section)) }
        </li>
};

declare %private function local:doc-header($node as element()*) as element(div) {
<div id="doc-header" class="doc-header text-center">
    <h1 class="doc-title">
        <i class="icon fa fa-paper-plane"></i> Quick Start</h1>
    <div class="meta">
        <i class="fa fa-clock-o"></i> Last updated: Jan 25th, 2016</div>        
</div>
};

declare %private function local:to-html($nodes as node()*) {
    for $node in $nodes
    return
        typeswitch ($node)
            case text() return
                $node
        (:   Needs an updated to select the right fa-fa-symbol, also the date ain't accurate should be fixed in local:)
            case element(book) return  
                let $meta := $node/bookinfo
                let $id := lower-case(replace($meta/title/text(), '\s', '-'))
                return
                <div class="container" role="main" id="{$id}">
                    <div id="doc-header" class="doc-header text-center">
                        <h1 class="doc-title">
                            <i class="icon fa fa-paper-plane"></i> {' ' || $meta/title}</h1>
                        <div class="meta">
                            <i class="fa fa-clock-o"></i>{' Last updated: ' || $meta/date}</div>        
                    </div>
                    <!-- //doc-header -->
                    <div class="doc-body">
                    {local:to-html($node/chapter)}

                    </div>
                    <!-- //doc-body -->
                </div>                             
(:            case element(article) return
                <article>
                    {local:process-children($node/section)}
                </article>:)
            case element(chapter) return
                 (<div class="content-inner">
                {local:process-children($node)}                
                </div>
              (:<!-- //content-inner -->:), 
              <div class="doc-sidebar hidden-xs">
                {local:sidebar($node)}            
              </div>
            (:<!-- //doc-sidebar -->:))
            case element(section) return
                let $id := lower-case(replace($node/@id, '\s', '-')) 
                return
                if ($node/@role = "media-object") then
                    local:media($node)
                else
                    <section id="{$id}" class="doc-section">
                        {local:process-children($node)}
                    </section>
            case element(abstract) return
                <blockquote>{local:process-children($node)}</blockquote>
            case element(col) return
                <col width="{$node/@width}">{local:process-children($node)}</col>
            case element(colgroup) return
                <colgroup>{local:process-children($node)}</colgroup>    
                
            case element(title) return
                let $level := count($node/(ancestor::chapter|ancestor::section))
                return
                    switch($level)
                        case 1 return ()
                        case 2 return element { "h2" } { attribute class{ 'section-title' }, local:process-children($node)}
                    default return element { "h" || $level } { attribute class{ 'block-title' }, local:process-children($node)}
            case element(para) return
                <p>{local:process-children($node)}</p>
            case element(emphasis) return
                <em>{local:process-children($node)}</em>
            case element(itemizedlist) return
                <ul class="list">{local:to-html($node/listitem)}</ul>
            case element(orderedlist) return
                <ol class="list">{local:to-html($node/listitem)}</ol>
            case element(listitem) return
                if ($node/parent::varlistentry) then
                    local:process-children($node)
                else
                    <li>{local:process-children($node)}</li>
            (: Call out :)
            case element(note) return
                <div class="callout-block callout-info">
                  <div class="icon-holder">
                    <i class="fa fa-info-circle"></i>
                  </div>
                  <!--//icon-holder-->
                  <div class="content">
                  {
                    if ($node/title) then
                        <h4 class="callout-title">{ local:to-html($node/title/node()) }</h4>
                    else
                        ()
                }
                    { local:to-html($node/* except $node/title) }
                  </div>
                  <!--//content-->
                </div>                
               
            case element(important) return
                <div class="callout-block callout-danger">
                  <div class="icon-holder">
                    <i class="fa fa-exclamation-triangle"></i>
                  </div>
                  <!--//icon-holder-->
                  <div class="content">
                  {
                    if ($node/title) then
                        <h4 class="callout-title">{ local:to-html($node/title/node()) }</h4>
                    else
                        ()
                }
                    { local:to-html($node/* except $node/title) }
                  </div>
                  <!--//content-->
                </div>     
            
            case element(variablelist) return
                let $spacing := $node/@spacing
                return
                    <dl class="dl-horizontal {if ($spacing = 'normal') then 'wide' else ''}">{local:process-children($node)}</dl>
            case element(varlistentry) return (
                <dt>{local:process-children($node/term)}</dt>,
                <dd>{local:to-html($node/listitem)}</dd>
                )
            (: media :)
            case element(figure) return
                if ($node/@role = "media-object") then
                    local:media($node)
                else
                    local:figure($node)
            case element(screenshot) return
                local:figure($node)
            case element(example) return
                local:figure($node)
            case element(screen) return
                local:code($node)
            case element(graphic) return
                let $align := $node/@align
                let $class := if ($align) then "img-float-" || $align else ()
                return
                    <img src="{$node/@fileref}">
                    { if ($class) then attribute class { $class } else () }
                    { if ($node/@width) then attribute width { $node/@width } else () }
                    </img>
            case element(mediaobject) return
                local:process-children($node)
            case element(imageobject) return
                local:process-children($node)
            case element(imagedata) return
                let $align := $node/@align
                let $class := if ($align) then "img-float-" || $align else ""
                return
                    <img src="{$node/@fileref}" class="{$class}"/>
            case element(videodata) return
                let $align := $node/@align
                let $class := if ($align) then "img-float-" || $align else ""
                return
                     <div class="col-md-6 col-sm-6 col-xs-12">
                        <h6 class="media-heading">{$node/title/text()}</h6>
                        <!-- 16:9 aspect ratio -->
                        <div class="embed-responsive embed-responsive-16by9">
                          <iframe class="embed-responsive-item" src="{$node/graphic/@fileref}" frameborder="0" allowfullscreen="true"></iframe>
                        </div>
                      </div>
            
            case element(ulink) return
                if ($node/@condition = '_blank')
                then
                    <a href="{$node/@url}" target="_blank">{local:process-children($node)}</a>
                else
                    <a href="{$node/@url}">{local:process-children($node)}</a>
            case element(xref) return
                <a href="#{$node/@linkend}">{root($node)/*//*[@id = $node/@linkend]/title/text()}</a>
                
            (: Code :)
            case element(synopsis) return
                local:code($node)
            case element(programlisting) return
                local:code($node)
            case element(procedure) return
                <div class="procedure">
                    <ol class="list">
                    {local:process-children($node)}
                    </ol>
                </div>
            case element(step) return
                <li>{local:process-children($node)}</li>
            case element(filename) return
                <code>{local:process-children($node)}</code>
            case element(toc) return
                <ul class="toc">
                {local:process-children($node)}
                </ul>
            case element(tocpart) return
                <li>{local:process-children($node)}</li>
            case element(tocentry) return
                local:process-children($node)
            (: Table :)
            case element(informaltable) return
                <table class="table table-striped">{$node/node()}</table>
            case element(table) return
                local:table($node)
            case element(tgroup) return
                local:process-children($node)
            case element(thead) return
                <thead>{local:process-children($node)}</thead>
            case element(tbody) return
                <tbody>{local:process-children($node)}</tbody>
            case element(row) return
                <tr>{local:process-children($node)}</tr>
            case element(entry) return
                if ($node/ancestor::thead) then
                    <th>{local:process-children($node)}</th>
                else
                    <td>{local:process-children($node)}</td>
            case element(guimenuitem) return
                <span class="guimenuitem">{local:process-children($node)}</span>
            case element(guibutton) return
                <span class="label label-primary">{local:process-children($node)}</span>
            case element(sgmltag) return
                <span class="sgmltag">&lt;{local:process-children($node)}&gt;</span>
            case element(exist:match) return
                <span class="hi">{$node/text()}</span>
            case element() return
                let $name := local-name($node)
                return
                    if ($name = $local:INLINE) then
                        <span class="{local-name($node)}">{local:process-children($node)}</span>
                    else
                        element { node-name($node) } {
                            $node/@*,
                            local:process-children($node)
                        }
            case document-node() return
                local:to-html($node/*)
            default return
                ()
};

declare %private function local:inline($node as node()) {
    <span class="{local-name($node)}">{local:process-children($node)}</span>
};

declare %private function local:figure($node as node()) {
    let $float := $node/@floatstyle
    return
        <figure>
            { if ($float) then attribute class { "float-" || $float } else () }
            {local:to-html($node/*[not(self::title)])}
            {
                if ($node/title) then
                    <figcaption>{local:process-children($node/title)}</figcaption>
                else
                    ()
            }
        </figure>
};

declare %private function local:media($node as element()) {
   
    
    <div class="media well">
        <a class="pull-left" href="#">
            <img class="media-object" src="{$node/graphic/@fileref}"/>
        </a>
        <div class="media-body">
            <h6 class="media-heading">{$node/title/text()}</h6>
            {
                for $child in $node/* except $node/title except $node/graphic
                return
                    local:to-html($child)
            }
        </div>
    </div>
};

declare %private function local:table($node as node()) {
    <table class="table table-striped table-condensed">{if ($node/@border) then attribute border {$node/@border} else () }
        {local:to-html($node/*[not(self::title)])}
        {
            if ($node/title) then
                <caption>{local:process-children($node/title)}</caption>
            else
                ()
        }
    </table>
};

declare %private function local:code($elem as element()) {
    let $lang :=
        if ($elem//markup) then
            "xml"
        else if ($elem/@language) then
            $elem/@language
        else
            ()
    return
    if (lower-case($lang) eq 'xquery')
    then (<div class="code-block">
            <pre>
                <code data-language="XQuery">{ replace($elem/string(), "^\s+", "") }</code>
            </pre>
        </div>)
    else (<div class="code-block">
            <pre>
                <code class="{$lang}">{ replace($elem/string(), "^\s+", "") }</code>
            </pre>
        </div>)
};

declare %private function local:process-children($elem as element()+) {
    for $child in $elem/node()
    return
        local:to-html($child)
};

declare %private function local:print-authors($root as element()) {
    <div class="authors">
    {
        for $author in $root/bookinfo/author
        return
            <address>
                <strong>{$author/firstname} {$author/surname}</strong>
                { for $jobtitle in $author/jobtitle return (<br/>, $author/jobtitle/text()) }
                { for $orgname in $author/orgname return (<br/>, $author/orgname/text()) }
                { for $email in $author/email return (<br/>, <a href="mailto:{$author/email}">{$author/email/text()}</a>) }
            </address>
    }
    </div>
};

local:to-html($local:test)