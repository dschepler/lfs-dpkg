<?xml version='1.0' encoding='ISO-8859-1'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

  <!-- This stylesheet contains misc params, attribute sets and templates
       for output formating.
       This file is for that templates that don't fit in other files. -->

    <!-- What space do you want between normal paragraphs. -->
  <xsl:attribute-set name="normal.para.spacing">
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="orphans">3</xsl:attribute>
    <xsl:attribute name="widows">3</xsl:attribute>
  </xsl:attribute-set>

    <!-- Properties associated with verbatim text. -->
  <xsl:attribute-set name="verbatim.properties">
    <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="hyphenate">false</xsl:attribute>
    <xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
    <xsl:attribute name="white-space-collapse">false</xsl:attribute>
    <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
    <xsl:attribute name="text-align">start</xsl:attribute>
  </xsl:attribute-set>

    <!-- Should verbatim environments be shaded? 1 =yes, 0 = no -->
  <xsl:param name="shade.verbatim" select="1"/>

    <!-- Properties that specify the style of shaded verbatim listings -->
  <xsl:attribute-set name="shade.verbatim.style">
    <xsl:attribute name="background-color">#E9E9E9</xsl:attribute>
    <xsl:attribute name="border-style">solid</xsl:attribute>
    <xsl:attribute name="border-width">0.5pt</xsl:attribute>
    <xsl:attribute name="border-color">#888</xsl:attribute>
    <xsl:attribute name="padding-start">5pt</xsl:attribute>
    <xsl:attribute name="padding-top">2pt</xsl:attribute>
    <xsl:attribute name="padding-bottom">2pt</xsl:attribute>
  </xsl:attribute-set>

    <!-- para:
           Skip empty "Home page" in packages.xml.
           Allow forced line breaks inside paragraphs emulating literallayout.
           Removed vertical space in variablelist. -->
    <!-- The original template is in {docbook-xsl}/fo/block.xsl -->
  <xsl:template match="para">
    <xsl:choose>
      <xsl:when test="child::ulink[@url=' ']"/>
      <xsl:when test="./@remap='verbatim'">
        <fo:block xsl:use-attribute-sets="verbatim.properties">
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:when test="ancestor::variablelist">
        <fo:block>
          <xsl:attribute name="space-before.optimum">0.1em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block xsl:use-attribute-sets="normal.para.spacing">
          <xsl:call-template name="anchor"/>
          <xsl:apply-templates/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- screen, literallayout:
          Self-made template that creates a fo:block wrapper with keep-together
          processing instruction support around the output generated by
          original screen templates. -->
  <xsl:template match="screen|literallayout">
    <xsl:variable name="keep.together">
      <xsl:call-template name="dbfo-attribute">
        <xsl:with-param name="pis"
                        select="processing-instruction('dbfo')"/>
        <xsl:with-param name="attribute" select="'keep-together'"/>
      </xsl:call-template>
    </xsl:variable>
    <fo:block>
      <xsl:attribute name="keep-together.within-column">
        <xsl:choose>
          <xsl:when test="$keep.together != ''">
            <xsl:value-of select="$keep.together"/>
          </xsl:when>
          <xsl:when test="$book-type = 'blfs'">auto</xsl:when>
          <xsl:otherwise>always</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-imports/>
    </fo:block>
  </xsl:template>

    <!-- literal:
           Be sure that literal will use allways normal font weight. -->
    <!-- The original template is in {docbook-xsl}/fo/inline.xsl -->
  <xsl:template match="literal">
    <fo:inline  font-weight="normal">
      <xsl:call-template name="inline.monoseq"/>
    </fo:inline>
  </xsl:template>

    <!-- inline.monoseq:
           Added hyphenate-url support to classname, exceptionname, interfacename,
           methodname, computeroutput, constant, envar, filename, function, code,
           literal, option, promt, systemitem, varname, sgmltag, tag, and uri -->
    <!-- The original template is in {docbook-xsl}/fo/inline.xsl -->
  <xsl:template name="inline.monoseq">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:choose>
            <xsl:when test="ancestor::para and not(ancestor::screen)
                            and not(descendant::ulink)">
              <xsl:call-template name="hyphenate-url">
                <xsl:with-param name="url">
                  <xsl:apply-templates/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <fo:inline xsl:use-attribute-sets="monospace.properties">
      <xsl:if test="@dir">
        <xsl:attribute name="direction">
          <xsl:choose>
            <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
            <xsl:otherwise>rtl</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>

    <!-- inline.italicmonoseq:
           Added hyphenate-url support to parameter, replaceable, structfield,
           function/parameter, and function/replaceable -->
    <!-- The original template is in {docbook-xsl}/fo/inline.xsl -->
  <xsl:template name="inline.italicmonoseq">
    <xsl:param name="content">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:choose>
            <xsl:when test="ancestor::para and not(ancestor::screen)
                            and not(descendant::ulink)">
              <xsl:call-template name="hyphenate-url">
                <xsl:with-param name="url">
                  <xsl:apply-templates/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:param>
    <fo:inline font-style="italic" xsl:use-attribute-sets="monospace.properties">
      <xsl:call-template name="anchor"/>
      <xsl:if test="@dir">
        <xsl:attribute name="direction">
          <xsl:choose>
            <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
            <xsl:otherwise>rtl</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>

    <!-- Show external URLs in italic font -->
  <xsl:attribute-set name="xref.properties">
    <xsl:attribute name="font-style">
      <xsl:choose>
        <xsl:when test="self::ulink">italic</xsl:when>
        <xsl:otherwise>inherit</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>


  <!-- Lists -->

    <!-- What spacing do you want before and after lists? -->
  <xsl:attribute-set name="list.block.spacing">
    <xsl:attribute name="space-before.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">0.6em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">0.8em</xsl:attribute>
  </xsl:attribute-set>

    <!-- What spacing do you want between list items? -->
  <xsl:attribute-set name="list.item.spacing">
    <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.6em</xsl:attribute>
  </xsl:attribute-set>

    <!-- Properties that apply to each list-block generated by itemizedlist. -->
  <xsl:attribute-set name="itemizedlist.properties"
                     use-attribute-sets="list.block.properties">
    <xsl:attribute name="text-align">left</xsl:attribute>
  </xsl:attribute-set>

    <!-- Format variablelists lists as blocks? 1 = yes, 0 = no
           Default variablelist format. We override it when necesary
           using the list-presentation processing instruction. -->
  <xsl:param name="variablelist.as.blocks" select="1"/>

    <!-- Specifies the longest term in variablelists.
         Used when list-presentation = list -->
  <xsl:param name="variablelist.max.termlength">35</xsl:param>

    <!-- varlistentry mode block:
           Addibg a bullet, left alignament, and @kepp-*.* attributes
           for packages and paches list. -->
    <!-- The original template is in {docbook-xsl}/fo/list.xsl -->
  <xsl:template match="varlistentry" mode="vl.as.blocks">
    <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="ancestor::variablelist/@role = 'materials'">
        <fo:block id="{$id}" xsl:use-attribute-sets="list.item.spacing"
                  keep-together.within-column="always" font-weight="bold"
                  keep-with-next.within-column="always" text-align="left">
          <xsl:text>&#x2022;   </xsl:text>
          <xsl:apply-templates select="term"/>
        </fo:block>
        <fo:block text-align="left"
                  keep-together.within-column="always"
                  keep-with-previous.within-column="always">
          <xsl:apply-templates select="listitem"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block id="{$id}" xsl:use-attribute-sets="list.item.spacing"
                  keep-together.within-column="always"
                  keep-with-next.within-column="always" margin-left="1em">
          <xsl:apply-templates select="term"/>
        </fo:block>
        <fo:block margin-left="2em">
          <xsl:apply-templates select="listitem"/>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

    <!-- segmentedlist:
           Making it an actual FO list to can indent items.
           Adjust vertical space. -->
    <!-- The original template is in {docbook-xsl}/fo/list.xsl -->
  <xsl:template match="segmentedlist">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <fo:list-block id="{$id}" provisional-distance-between-starts="12em"
                   provisional-label-separation="1em"
                   keep-together.within-column="always">
      <xsl:choose>
        <xsl:when test="ancestor::appendix[@id='appendixc']">
          <xsl:attribute name="space-before.optimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.4em</xsl:attribute>
          <xsl:attribute name="space-after.optimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-after.minimum">0em</xsl:attribute>
          <xsl:attribute name="space-after.maximum">0.4em</xsl:attribute>
          <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="space-before.optimum">0.4em</xsl:attribute>
          <xsl:attribute name="space-before.minimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-before.maximum">0.6em</xsl:attribute>
          <xsl:attribute name="space-after.optimum">0.4em</xsl:attribute>
          <xsl:attribute name="space-after.minimum">0.2em</xsl:attribute>
          <xsl:attribute name="space-after.maximum">0.6em</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="seglistitem/seg"/>
    </fo:list-block>
  </xsl:template>

    <!-- seg:
           Self-made template based on the original seg template
           found in {docbook-xsl}/fo/list.xsl
           Making segmentedlist an actual FO list to can indent items. -->
  <xsl:template match="seglistitem/seg">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="segnum" select="count(preceding-sibling::seg)+1"/>
    <xsl:variable name="seglist" select="ancestor::segmentedlist"/>
    <xsl:variable name="segtitles" select="$seglist/segtitle"/>
    <fo:list-item xsl:use-attribute-sets="compact.list.item.spacing">
      <fo:list-item-label end-indent="label-end()" text-align="start">
        <fo:block>
          <fo:inline font-weight="bold">
            <xsl:apply-templates select="$segtitles[$segnum=position()]"
                                 mode="segtitle-in-seg"/>
            <xsl:text>:</xsl:text>
          </fo:inline>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block id="{$id}">
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

    <!-- simplelist:
           Self-made template. Wrap it into a fo:block and process member childs.
           If @type is specified, the original templates will be used.
           NOTE: when using type='horiz' or type='vert', FOP-0.93 will complaints
             about not supported table-layout="auto" -->
  <xsl:template match="simplelist">
    <fo:block xsl:use-attribute-sets="simplelist.properties">
      <xsl:apply-templates mode="condensed"/>
    </fo:block>
  </xsl:template>

    <!-- member:
           Self-made template to wrap it into a fo:block using customized
           properties. -->
  <xsl:template match="member" mode="condensed">
    <fo:block xsl:use-attribute-sets="simplelist.properties">
      <xsl:call-template name="simple.xlink">
        <xsl:with-param name="content">
          <xsl:apply-templates/>
        </xsl:with-param>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

    <!-- Properties associated with our simplelist format. -->
  <xsl:attribute-set name="simplelist.properties">
    <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
    <xsl:attribute name="space-before.optimum">0em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">0.2em</xsl:attribute>
  </xsl:attribute-set>


  <!-- Revision History -->

    <!-- revhistory titlepage:
           Self-made template to add missing support on bookinfo. -->
  <xsl:template match="revhistory" mode="book.titlepage.verso.auto.mode">
    <fo:block space-before.optimum="2em"
              space-before.minimum="1.5em"
              space-before.maximum="2.5em">
      <xsl:apply-templates select="." mode="book.titlepage.verso.mode"/>
    </fo:block>
  </xsl:template>

    <!-- revhitory title properties -->
  <xsl:attribute-set name="revhistory.title.properties">
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

    <!-- revhistory/revision mode titlepage.mode:
           Removed authorinitials | author support placing
           revremark | revdescription instead on that table-cell. -->
    <!-- The original template is in {docbook-xsl}/fo/titlepage.xsl -->
  <xsl:template match="revhistory/revision" mode="titlepage.mode">
    <xsl:variable name="revnumber" select="revnumber"/>
    <xsl:variable name="revdate"   select="date"/>
    <xsl:variable name="revremark" select="revremark|revdescription"/>
    <fo:table-row>
      <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
        <fo:block>
          <xsl:if test="$revnumber">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'Revision'"/>
            </xsl:call-template>
            <xsl:call-template name="gentext.space"/>
            <xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/>
          </xsl:if>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
        <fo:block>
          <xsl:apply-templates select="$revdate[1]"/>
        </fo:block>
      </fo:table-cell>
      <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
        <fo:block>
          <xsl:apply-templates select="$revremark[1]"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:template>

</xsl:stylesheet>
