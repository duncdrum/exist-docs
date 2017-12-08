xquery version "3.0";

import module namespace request="http://exist-db.org/xquery/request";
import module namespace login="http://exist-db.org/xquery/login" at "resource:org/exist/xquery/modules/persistentlogin/login.xql";
import module namespace xdb = "http://exist-db.org/xquery/xmldb";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;
    
let $query := request:get-parameter("q", ())
return
if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{concat(request:get-uri(), '/')}"/>
    </dispatch>
    
else if ($exist:path eq "/") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/templates/content.html">
        </forward>
        <view>
            <!-- pass the results through view.xql -->
			<forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="doc" value="documentation.xml"/>
                <set-attribute name="$exist:prefix" value="{$exist:prefix}"/>
                <set-attribute name="$exist:controller" value="{$exist:controller}"/>
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if ($exist:resource eq "login") then
    let $loggedIn := login:set-user("org.exist.login", (), true())
    return
        try {
            util:declare-option("exist:serialize", "method=json"),
            <status>
                <user>{request:get-attribute("org.exist.login.user")}</user>
                <isAdmin json:literal="true">{ xmldb:is-admin-user(request:get-attribute("org.exist.login.user")) }</isAdmin>
            </status>
        } catch * {
            response:set-status-code(401),
            <status>{$err:description}</status>
        }    

(: Pass all requests to XML files through to view.xql, which handles HTML templating :)
else if (ends-with($exist:resource, ".xml")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/templates/content.html">
        </forward>
        <view>
            <!-- pass the results through view.xql -->
			<forward url="{$exist:controller}/modules/view.xql">
                <add-parameter name="doc" value="{$exist:resource}"/>
                <set-attribute name="$exist:prefix" value="{$exist:prefix}"/>
                <set-attribute name="$exist:controller" value="{$exist:controller}"/>
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>

(: Pass all requests to HTML files through view.xql, which handles HTML templating :)
else if (ends-with($exist:resource, ".html")) then
    let $loggedIn := login:set-user("org.exist.login", (), true())
    return        
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
			<forward url="{$exist:controller}/modules/view.xql">
                <set-attribute name="$exist:prefix" value="{$exist:prefix}"/>
                <set-attribute name="$exist:controller" value="{$exist:controller}"/>
            </forward>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/view.xql"/>
        </error-handler>
    </dispatch>
    
else if ($exist:resource = "reindex.xql") then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        {login:set-user("org.exist.login", (), false())}
    </dispatch>    

else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}"/>
    </dispatch>

(: images, css are contained in the top /resources/ collection. :)
(: Relative path requests from sub-collections are redirected there :)
else if (contains($exist:path, "/resources/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/resources/{substring-after($exist:path, '/resources/')}"/>
    </dispatch>

else
    (: everything else is passed through :)
    <ignore xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </ignore>
