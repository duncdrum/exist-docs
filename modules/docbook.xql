xquery version "3.0";

module namespace docbook="http://docbook.org/ns/docbook";

import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";
import module namespace templates="http://exist-db.org/xquery/templates" at "templates.xql";
import module namespace dq="http://exist-db.org/xquery/documentation/search" at "search.xql";

declare variable $docbook:INLINE :=
    ("filename", "classname", "methodname", "option", "command", "parameter", "guimenu", "guimenuitem", "guibutton", "function", "envar");
(:~
 : Load a docbook document. If a query was specified, re-run the query on the document
 : to get matches highlighted.
 :)
declare
    %public %templates:default("field", "all")
function docbook:load($node as node(), $model as map(*), $q as xs:string?, $doc as xs:string?, $field as xs:string) {
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
declare %public function docbook:to-html($node as node(), $model as map(*)) {
    docbook:to-html($model("doc"))
};

(:~
 : Generate a table of contents.
 :)
declare %public function docbook:toc($node as node(), $model as map(*)) as element(ul){
    <ul id="doc-menu" class="nav doc-menu" data-spy="affix">
      {docbook:print-sections($model("doc")/*/(chapter|section))}
    </ul>
};


declare %private function docbook:print-sections($sections as element()*) {
    for $section in $sections
    let $id := if ($section/@id) 
        then lower-case(replace($section/@id, '\s', '-')) 
        else concat("D", lower-case(replace($section/@exist:id, '\s', '-')))
    let $title := lower-case(replace($section/title/text(), '\s', '-'))

    return
        <li>
          <a class="scrollto" href="#{$id}">{ $section/title/text() }</a>
            { docbook:print-sections($section/(chapter|section)) }
        </li>
};


declare %public function docbook:sidebar($chapter as element()) as element(ul){
       
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

declare %private function docbook:doc-header($node as element()*) as element(div) {
(:Placeholder will determine the icon later:)
<div id="doc-header" class="doc-header text-center">
    <h1 class="doc-title">
        <i class="icon fa fa-paper-plane"></i> Quick Start</h1>
    <div class="meta">
        <i class="fa fa-clock-o"></i> Last updated: Jan 25th, 2016</div>        
</div>
};

declare %private function docbook:to-html($nodes as node()*) {
    for $node in $nodes
    return
        typeswitch ($node)
            case text() return
                $node
        (:   Needs an updated to select the right fa-fa-symbol, also the date ain't accurate should be fixed in docbook:)
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
                        <div class="doc-content">    
                            {docbook:to-html($node/chapter)}  
                        </div>
                        <!-- //doc-content -->
                        <div class="doc-sidebar hidden-xs">
                            {docbook:sidebar($node)}
                          </div>
                         <!-- //doc-sidebar -->
                    </div>
                    <!-- //doc-body -->
                </div>                             
(:            case element(article) return
                <article>
                    {docbook:process-children($node/section)}
                </article>:)
            case element(chapter) return
                <div class="content-inner">
                {docbook:process-children($node)}                
                </div>
              (:<!-- //content-inner -->:)
            case element(section) return
                let $id := lower-case(replace($node/@id, '\s', '-')) 
                return
                if ($node/@role = "media-object") then
                    docbook:media($node)
                else
                    <section id="{$id}" class="doc-section">
                        {docbook:process-children($node)}
                    </section>
            case element(abstract) return
                <blockquote>{docbook:process-children($node)}</blockquote>
            case element(col) return
                <col width="{$node/@width}">{docbook:process-children($node)}</col>
            case element(colgroup) return
                <colgroup>{docbook:process-children($node)}</colgroup>    
                
            case element(title) return
                let $level := count($node/(ancestor::chapter|ancestor::section))
                return
                    switch($level)
                        case 1 return docbook:process-children($node)
                        case 2 return element { "h2" } { attribute class{ 'section-title' }, docbook:process-children($node)}
                    default return element { "h" || $level } { attribute class{ 'block-title' }, docbook:process-children($node)}
            case element(para) return
                <p>{docbook:process-children($node)}</p>
            case element(emphasis) return
                <em>{docbook:process-children($node)}</em>
            case element(itemizedlist) return
                <ul class="list">{docbook:to-html($node/listitem)}</ul>
            case element(orderedlist) return
                <ol class="list">{docbook:to-html($node/listitem)}</ol>
            case element(listitem) return
                if ($node/parent::varlistentry) then
                    docbook:process-children($node)
                else
                    <li>{docbook:process-children($node)}</li>
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
                        <h4 class="callout-title">{ docbook:to-html($node/title/node()) }</h4>
                    else
                        ()
                }
                    { docbook:to-html($node/* except $node/title) }
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
                        <h4 class="callout-title">{ docbook:to-html($node/title/node()) }</h4>
                    else
                        ()
                }
                    { docbook:to-html($node/* except $node/title) }
                  </div>
                  <!--//content-->
                </div>     
            
            case element(variablelist) return
                let $spacing := $node/@spacing
                return
                    <dl class="dl-horizontal {if ($spacing = 'normal') then 'wide' else ''}">{docbook:process-children($node)}</dl>
            case element(varlistentry) return (
                <dt>{docbook:process-children($node/term)}</dt>,
                <dd>{docbook:to-html($node/listitem)}</dd>
                )
            (: media :)
            case element(figure) return
                if ($node/@role = "media-object") then
                    docbook:media($node)
                else
                    docbook:figure($node)
            case element(screenshot) return
                docbook:figure($node)
            case element(example) return
                docbook:figure($node)
            case element(screen) return
                docbook:code($node)
            case element(graphic) return
                let $align := $node/@align
                let $class := if ($align) then "img-float-" || $align else ()
                return
                    <img src="{$node/@fileref}">
                    { if ($class) then attribute class { $class } else () }
                    { if ($node/@width) then attribute width { $node/@width } else () }
                    </img>
            case element(mediaobject) return
                docbook:process-children($node)
            case element(imageobject) return
                docbook:process-children($node)
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
                    <a href="{$node/@url}" target="_blank">{docbook:process-children($node)}</a>
                else
                    <a href="{$node/@url}">{docbook:process-children($node)}</a>
            case element(xref) return
                <a href="#{$node/@linkend}">{root($node)/*//*[@id = $node/@linkend]/title/text()}</a>
                
            (: Code :)
            case element(synopsis) return
                docbook:code($node)
            case element(programlisting) return
                docbook:code($node)
            case element(procedure) return
                <div class="procedure">
                    <ol class="list">
                    {docbook:process-children($node)}
                    </ol>
                </div>
            case element(step) return
                <li>{docbook:process-children($node)}</li>
            case element(filename) return
                <code>{docbook:process-children($node)}</code>
            case element(toc) return
                <ul class="toc">
                {docbook:process-children($node)}
                </ul>
            case element(tocpart) return
                <li>{docbook:process-children($node)}</li>
            case element(tocentry) return
                docbook:process-children($node)
            (: Table :)
            case element(informaltable) return
                <table class="table table-striped">{$node/node()}</table>
            case element(table) return
                docbook:table($node)
            case element(tgroup) return
                docbook:process-children($node)
            case element(thead) return
                <thead>{docbook:process-children($node)}</thead>
            case element(tbody) return
                <tbody>{docbook:process-children($node)}</tbody>
            case element(row) return
                <tr>{docbook:process-children($node)}</tr>
            case element(entry) return
                if ($node/ancestor::thead) then
                    <th>{docbook:process-children($node)}</th>
                else
                    <td>{docbook:process-children($node)}</td>
            case element(guimenuitem) return
                <span class="guimenuitem">{docbook:process-children($node)}</span>
            case element(guibutton) return
                <span class="label label-primary">{docbook:process-children($node)}</span>
            case element(sgmltag) return
                <span class="sgmltag">&lt;{docbook:process-children($node)}&gt;</span>
            case element(exist:match) return
                <span class="hi">{$node/text()}</span>
            case element() return
                let $name := local-name($node)
                return
                    if ($name = $docbook:INLINE) then
                        <span class="{local-name($node)}">{docbook:process-children($node)}</span>
                    else
                        element { node-name($node) } {
                            $node/@*,
                            docbook:process-children($node)
                        }
            case document-node() return
                docbook:to-html($node/*)
            default return
                ()
};

declare %private function docbook:inline($node as node()) {
    <span class="{local-name($node)}">{docbook:process-children($node)}</span>
};

declare %private function docbook:figure($node as node()) {
    let $float := $node/@floatstyle
    return
        <figure>
            { if ($float) then attribute class { "float-" || $float } else () }
            {docbook:to-html($node/*[not(self::title)])}
            {
                if ($node/title) then
                    <figcaption>{docbook:process-children($node/title)}</figcaption>
                else
                    ()
            }
        </figure>
};

declare %private function docbook:media($node as element()) {
   
    
    <div class="media well">
        <a class="pull-left" href="#">
            <img class="media-object" src="{$node/graphic/@fileref}"/>
        </a>
        <div class="media-body">
            <h6 class="media-heading">{$node/title/text()}</h6>
            {
                for $child in $node/* except $node/title except $node/graphic
                return
                    docbook:to-html($child)
            }
        </div>
    </div>
};

declare %private function docbook:table($node as node()) {
    <table class="table table-striped table-condensed">{if ($node/@border) then attribute border {$node/@border} else () }
        {docbook:to-html($node/*[not(self::title)])}
        {
            if ($node/title) then
                <caption>{docbook:process-children($node/title)}</caption>
            else
                ()
        }
    </table>
};

declare %private function docbook:code($elem as element()) {
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

declare %private function docbook:process-children($elem as element()+) {
    for $child in $elem/node()
    return
        docbook:to-html($child)
};

declare %private function docbook:print-authors($root as element()) {
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
