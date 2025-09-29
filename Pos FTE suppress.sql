<saw:report xmlns:saw="com.siebel.analytics.web/report/v1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sawx="com.siebel.analytics.web/expression/v1.1" xmlVersion="201201160">
   <saw:criteria xsi:type="saw:simpleCriteria" subjectArea="&quot;Workforce Management - Position Real Time&quot;" withinHierarchy="true">
      <saw:columns>
         <saw:column xsi:type="saw:regularColumn" columnID="c70c12335b8f4ad81">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Department"."Department Name"</sawx:expr></saw:columnFormula>
            <saw:dimensionSelection>
               <saw:selectionStep stepID="1" type="startWith" category="member">
                  <saw:stepMembers xsi:type="saw:staticMemberGroupDef">
                     <saw:staticMemberGroup>
                        <saw:members xsi:type="saw:specialValueMembers">
                           <saw:value specialValue="all"/></saw:members></saw:staticMemberGroup></saw:stepMembers></saw:selectionStep></saw:dimensionSelection></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cee35b69d829eccae">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Position Details"."Position Code"</sawx:expr></saw:columnFormula>
            <saw:dimensionSelection>
               <saw:selectionStep stepID="1" type="startWith" category="member">
                  <saw:stepMembers xsi:type="saw:staticMemberGroupDef">
                     <saw:staticMemberGroup>
                        <saw:members xsi:type="saw:specialValueMembers">
                           <saw:value specialValue="all"/></saw:members></saw:staticMemberGroup></saw:stepMembers></saw:selectionStep></saw:dimensionSelection></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c2c1768e7084758bd">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Position Details"."Position Name"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c7bef624304396e0d">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Position"."Position Active Flag"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec visibility="hidden" suppress="suppress" wrapText="true"/></saw:displayFormat>
            <saw:columnHeading>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:columnHeading></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c518075ebd16a4f6b">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Worker Assignment"."Full-Time Equivalent"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec suppress="repeat" wrapText="true">
                  <saw:dataFormat xsi:type="saw:number" commas="false" negativeType="minus" minDigits="4" maxDigits="4"/></saw:formatSpec></saw:displayFormat>
            <saw:columnHeading>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:columnHeading></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c187ebb28f708f3e7">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Worker"."Employee List Name"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec suppress="suppress" wrapText="true"/></saw:displayFormat>
            <saw:columnHeading>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:columnHeading></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cee8440243e722452">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Worker Assignment Details"."Assignment Status Type"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec visibility="hidden" suppress="suppress" wrapText="true"/></saw:displayFormat>
            <saw:columnHeading>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:columnHeading></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c3ad41437d702a155">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Worker Assignment Details"."Assignment Type"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec visibility="hidden" suppress="suppress" wrapText="true"/></saw:displayFormat>
            <saw:columnHeading>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:columnHeading></saw:column>
         <saw:column columnID="c348025c6c76dcc71" xsi:type="saw:regularColumn">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Position"."Position FTE"-"Workforce Management - Worker Assignment Real Time"."Worker Assignment"."Full-Time Equivalent"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec suppress="suppress" wrapText="true" hAlign="right" vAlign="top" interaction="none">
                  <saw:dataFormat xsi:type="saw:number" minDigits="4" maxDigits="4" commas="false" negativeType="minus"/></saw:formatSpec></saw:displayFormat>
            <saw:tableHeading/>
            <saw:columnHeading>
               <saw:caption fmt="text">
                  <saw:text>Variance FTE</saw:text></saw:caption>
               <saw:displayFormat>
                  <saw:formatSpec interaction="none"/></saw:displayFormat></saw:columnHeading></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c3944a7bc29e472bd">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Position"."Position FTE"</sawx:expr></saw:columnFormula>
            <saw:displayFormat>
               <saw:formatSpec suppress="suppress" wrapText="true" className="display:none">
                  <saw:dataFormat xsi:type="saw:number" commas="false" negativeType="minus" minDigits="4" maxDigits="4"/></saw:formatSpec>
               <saw:conditionalDisplayFormats>
                  <saw:conditionalDisplayFormat>
                     <saw:formatRule>
                        <saw:condition>
                           <sawx:expr xsi:type="sawx:comparison" op="notNull">
                              <sawx:expr xsi:type="sawx:columnRefExpr" columnID="c3944a7bc29e472bd"/></sawx:expr></saw:condition>
                        <saw:formatSpec wrapText="true" style="display:none"/></saw:formatRule></saw:conditionalDisplayFormat></saw:conditionalDisplayFormats></saw:displayFormat>
            <saw:columnHeading>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:columnHeading></saw:column></saw:columns>
      <saw:filter>
         <sawx:expr xsi:type="sawx:logical" op="and">
            <sawx:expr xsi:type="sawx:comparison" op="equal">
               <sawx:expr xsi:type="sawx:columnExpression" formulaUse="code" displayUse="display">
                  <saw:columnFormula formulaUse="display">
                     <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Worker Assignment Details"."Assignment Status Type"</sawx:expr></saw:columnFormula></sawx:expr>
               <sawx:expr xsi:type="xsd:string">ACTIVE</sawx:expr></sawx:expr>
            <sawx:expr xsi:type="sawx:comparison" op="equal">
               <sawx:expr xsi:type="sawx:columnExpression" formulaUse="code" displayUse="display">
                  <saw:columnFormula formulaUse="display">
                     <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Worker Assignment Details"."Assignment Type"</sawx:expr></saw:columnFormula></sawx:expr>
               <sawx:expr xsi:type="xsd:string">E</sawx:expr></sawx:expr>
            <sawx:expr xsi:type="sawx:comparison" op="equal">
               <sawx:expr xsi:type="sawx:columnExpression" formulaUse="code" displayUse="display">
                  <saw:columnFormula formulaUse="display">
                     <sawx:expr xsi:type="sawx:sqlExpression">"Workforce Management - Worker Assignment Real Time"."Position"."Position Active Flag"</sawx:expr></saw:columnFormula></sawx:expr>
               <sawx:expr xsi:type="xsd:string">A</sawx:expr></sawx:expr></sawx:expr></saw:filter></saw:criteria>
   <saw:views currentView="0">
      <saw:view xsi:type="saw:compoundView" name="compoundView!1">
         <saw:cvTable>
            <saw:cvRow>
               <saw:cvCell viewName="titleView!1"/></saw:cvRow>
            <saw:cvRow>
               <saw:cvCell viewName="tableView!1"/></saw:cvRow></saw:cvTable></saw:view>
      <saw:view xsi:type="saw:titleView" name="titleView!1" includeName="true" startedDisplay="none"/>
      <saw:view xsi:type="saw:tableView" name="tableView!1" scrollingEnabled="false" deck="top" rowsPerPage="50">
         <saw:edges>
            <saw:edge axis="page" showColumnHeader="true">
               <saw:edgeLayers>
                  <saw:edgeLayer type="column" columnID="c70c12335b8f4ad81"/></saw:edgeLayers></saw:edge>
            <saw:edge axis="section">
               <saw:displayGrandTotals>
                  <saw:displayGrandTotal id="gt_section" grandTotalPosition="none"/></saw:displayGrandTotals>
               <saw:displayFormat>
                  <saw:formatSpec/></saw:displayFormat></saw:edge>
            <saw:edge axis="row" showColumnHeader="true">
               <saw:displayGrandTotals>
                  <saw:displayGrandTotal id="gt_row" grandTotalPosition="after"/></saw:displayGrandTotals>
               <saw:edgeLayers>
                  <saw:edgeLayer type="column" columnID="c2c1768e7084758bd">
                     <saw:levels>
                        <saw:level>
                           <saw:displaySubTotal id="st_c2c1768e7084758bd" subTotalPosition="after"/></saw:level></saw:levels></saw:edgeLayer>
                  <saw:edgeLayer type="column" columnID="cee35b69d829eccae">
                     <saw:levels>
                        <saw:level>
                           <saw:displaySubTotal id="st_cee35b69d829eccae" subTotalPosition="none"/></saw:level></saw:levels></saw:edgeLayer>
                  <saw:edgeLayer type="column" columnID="c187ebb28f708f3e7" visibility="visible"/>
                  <saw:edgeLayer type="column" columnID="c7bef624304396e0d"/>
                  <saw:edgeLayer type="column" columnID="c518075ebd16a4f6b" aggRule="sum" visibility="visible"/>
                  <saw:edgeLayer type="column" columnID="cee8440243e722452" visibility="visible"/>
                  <saw:edgeLayer type="column" columnID="c3ad41437d702a155" visibility="visible"/>
                  <saw:edgeLayer type="column" columnID="c348025c6c76dcc71">
                     <saw:memberFormat>
                        <saw:displayFormat>
                           <saw:formatSpec/></saw:displayFormat></saw:memberFormat></saw:edgeLayer>
                  <saw:edgeLayer type="column" columnID="c3944a7bc29e472bd" reportAgg="false"/></saw:edgeLayers></saw:edge>
            <saw:edge axis="column" showColumnHeader="rollover"/></saw:edges>
         <saw:pageEdgeState>
            <saw:QDR>
               <saw:staticMemberGroup>
                  <saw:groupType>
                     <sawx:columnRefExpr columnID="c70c12335b8f4ad81"/></saw:groupType>
                  <saw:members xsi:type="saw:stringMembers">
                     <saw:value>Facilities</saw:value></saw:members></saw:staticMemberGroup></saw:QDR>
            <saw:selectionGroups>
               <saw:selectionGroup columnID="c70c12335b8f4ad81" groupID="0"/></saw:selectionGroups></saw:pageEdgeState>
         <saw:greenBarFormat greenBar="allLayers" enabled="false">
            <saw:formatSpec backgroundColor="#CCCCCC"/></saw:greenBarFormat></saw:view></saw:views></saw:report>