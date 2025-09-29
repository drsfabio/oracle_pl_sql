<saw:report xmlns:saw="com.siebel.analytics.web/report/v1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:sawx="com.siebel.analytics.web/expression/v1.1" xmlVersion="201201160" appObjectID="9c0ff666-4652-448f-bc08-40aba6b0211b~11.13.22.01.0.0">  
   <saw:criteria xsi:type="saw:simpleCriteria" subjectArea="&quot;Recruiting - Recruiting Real Time&quot;" withinHierarchy="true">    
      <saw:columns>      
         <saw:column xsi:type="saw:regularColumn" columnID="c3c2b37816f3606e0">        
            <saw:columnFormula>          
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Basic Information"."Requisition Title"</sawx:expr>        </saw:columnFormula>        
            <saw:displayFormat>          
               <saw:formatSpec suppress="suppress" wrapText="true" interaction="none"/>        </saw:displayFormat>        
            <saw:columnHeading>          
               <saw:displayFormat>            
                  <saw:formatSpec interaction="none"/>          </saw:displayFormat>        </saw:columnHeading>      </saw:column>      
         <saw:column xsi:type="saw:regularColumn" columnID="c2633b212bd4ef795">        
            <saw:columnFormula>          
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Basic Information"."Requisition Number"</sawx:expr>        </saw:columnFormula>        
            <saw:displayFormat>          
               <saw:formatSpec suppress="suppress" wrapText="true" interaction="none"/>        </saw:displayFormat>        
            <saw:columnHeading>          
               <saw:displayFormat>            
                  <saw:formatSpec interaction="none"/>          </saw:displayFormat>        </saw:columnHeading>      </saw:column>      
         <saw:column xsi:type="saw:regularColumn" columnID="c56f4556a94fb6f7f">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Basic Information"."Business Justification"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c08de9310d5ea082b">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Basic Information"."Requisition Type"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="ce91f632909f0d26d">        
            <saw:columnFormula>          
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Hiring Team"."Recruiter Full Name"</sawx:expr>        </saw:columnFormula>        
            <saw:displayFormat>          
               <saw:formatSpec suppress="suppress" wrapText="true" interaction="none"/>        </saw:displayFormat>        
            <saw:columnHeading>          
               <saw:displayFormat>            
                  <saw:formatSpec interaction="none"/>          </saw:displayFormat>        </saw:columnHeading>      </saw:column>      
         <saw:column xsi:type="saw:regularColumn" columnID="c83661cf4cf6df907">        
            <saw:columnFormula>          
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Dates"."Creation Date"</sawx:expr>        </saw:columnFormula>        
            <saw:displayFormat>          
               <saw:formatSpec suppress="suppress" wrapText="true" interaction="none"/>        </saw:displayFormat>        
            <saw:tableHeading>          
               <saw:caption fmt="text" captionID="kcap1527552105603_4">            
                  <saw:text>Job Requisition - Dates</saw:text>          </saw:caption>        </saw:tableHeading>        
            <saw:columnHeading>          
               <saw:caption fmt="text" captionID="kcap1527552105603_5">            
                  <saw:text>Requisition Creation Date</saw:text>          </saw:caption>          
               <saw:displayFormat>            
                  <saw:formatSpec interaction="none"/>          </saw:displayFormat>        </saw:columnHeading>      </saw:column>      
         <saw:column xsi:type="saw:regularColumn" columnID="c6e380866c95c09a5">        
            <saw:columnFormula>          
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Offer - Basic Information"."Accepted Date"</sawx:expr>        </saw:columnFormula>        
            <saw:tableHeading>          
               <saw:caption fmt="text" captionID="kcap1527552105603_6">            
                  <saw:text>Job Offer - Basic Information</saw:text>          </saw:caption>        </saw:tableHeading>        
            <saw:columnHeading>          
               <saw:caption fmt="text" captionID="kcap1527552105603_7">            
                  <saw:text>Offer Accepted Date</saw:text>          </saw:caption>        </saw:columnHeading>      </saw:column>      
         <saw:column xsi:type="saw:regularColumn" columnID="cddabc4c8d896b131">        
            <saw:columnFormula>          
               <sawx:expr xsi:type="sawx:sqlExpression">CAST(TIMESTAMPDIFF(SQL_TSI_DAY, "Job Requisition - Dates"."Creation Date", MAX("Job Offer - Basic Information"."Accepted Date" BY "Job Requisition - Basic Information"."Requisition Id")) AS INT)</sawx:expr>        </saw:columnFormula>        
            <saw:displayFormat>          
               <saw:formatSpec suppress="suppress" wrapText="true"/>        </saw:displayFormat>        
            <saw:tableHeading>          
               <saw:caption fmt="text" oldID="kcap1527033706507_56" captionID="kcap1527292906189_1">            
                  <saw:text>Job Requisition - Dates</saw:text>          </saw:caption>        </saw:tableHeading>        
            <saw:columnHeading>          
               <saw:caption fmt="text" oldID="kcap1527292906189_2" captionID="kcap1527897705050_5">            
                  <saw:text># Time to Fill (Days)</saw:text>          </saw:caption>          
               <saw:displayFormat>            
                  <saw:formatSpec/>          </saw:displayFormat>        </saw:columnHeading>      </saw:column>    
         <saw:column xsi:type="saw:regularColumn" columnID="c987fe6473c555cf8">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Basic Information"."Requisition Type"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c81ab573ba753c2db">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Basic Information"."Recruiting Type"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c36383b66c84c65cc">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Additional Details"."Regular or Temporary"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cd49b4f749b93c56d">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Additional Details"."Full Time or Part Time"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c69a7f97682d96455">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Progression"."Current Phase"</sawx:expr></saw:columnFormula>
            <saw:dimensionSelection>
               <saw:selectionStep stepID="1" type="startWith" category="member">
                  <saw:stepMembers xsi:type="saw:staticMemberGroupDef">
                     <saw:staticMemberGroup>
                        <saw:members xsi:type="saw:specialValueMembers">
                           <saw:value specialValue="all"/></saw:members></saw:staticMemberGroup></saw:stepMembers></saw:selectionStep>
               <saw:selectionStep stepID="2" type="add" category="calcItem">
                  <saw:calcItem function="CountDistinct" hideDetails="false" id="calc_0e349d9a461eda34" addToAllViews="true">
                     <saw:caption>
                        <saw:text>Nombre de candidatures à la phase Nouvelle</saw:text></saw:caption>
                     <sawx:expr xsi:type="sawx:calcItemExpr">
                        <sawx:expr xsi:type="sawx:calcFunction" op="countDistinct">
                           <sawx:expr xsi:type="saw:memberExpr">
                              <saw:staticMemberGroup>
                                 <saw:members xsi:type="saw:stringMembers">
                                    <saw:value>Nouvelle</saw:value></saw:members></saw:staticMemberGroup></sawx:expr></sawx:expr></sawx:expr></saw:calcItem></saw:selectionStep></saw:dimensionSelection></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cd37bd1664a7903ba">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Requisition - Progression"."Current State"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cc373f914af272bad">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Facts - Job Application Counts"."Number of Active Job Applications"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cd6e825316da76262">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Facts - Job Application Counts"."Number of Job Applications Currently in Offer Phase"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cc8fc7f8391f0da9f">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Candidate Details"."Candidate Display Name"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="cc8fc7f8391f0da9f_d1">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Candidate Details"."Person Identifier"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c54fdfeaa1b3defad">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Application - Progression"."Current Phase"</sawx:expr></saw:columnFormula>
            <saw:dimensionSelection>
               <saw:selectionStep stepID="1" type="startWith" category="member">
                  <saw:stepMembers xsi:type="saw:staticMemberGroupDef">
                     <saw:staticMemberGroup>
                        <saw:members xsi:type="saw:specialValueMembers">
                           <saw:value specialValue="all"/></saw:members></saw:staticMemberGroup></saw:stepMembers></saw:selectionStep>
               <saw:selectionStep stepID="2" type="add" category="calcItem">
                  <saw:calcItem function="CountDistinct" hideDetails="false" id="calc_bb1832f39c37d116" addToAllViews="true">
                     <saw:caption>
                        <saw:text>Nombre de candidatures à la phase Nouvelle</saw:text></saw:caption>
                     <saw:displayFormat>
                        <saw:formatSpec/></saw:displayFormat>
                     <sawx:expr xsi:type="sawx:calcItemExpr">
                        <sawx:expr xsi:type="sawx:calcFunction" op="countDistinct">
                           <sawx:expr xsi:type="saw:memberExpr">
                              <saw:staticMemberGroup>
                                 <saw:members xsi:type="saw:stringMembers">
                                    <saw:value>Nouvelle</saw:value></saw:members></saw:staticMemberGroup></sawx:expr></sawx:expr></sawx:expr></saw:calcItem></saw:selectionStep></saw:dimensionSelection></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="ce0ef2138fa185a67">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Application - Progression"."Current Phase"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c4429188037729b9c">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"Job Application - Progression"."Current Phase"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c4ba2d40db12e974a">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"HR Position"."Position Name"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c4e7141245c488256">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"HR Position"."Position Name"</sawx:expr></saw:columnFormula></saw:column>
         <saw:column xsi:type="saw:regularColumn" columnID="c4102b958f0d70d92">
            <saw:columnFormula>
               <sawx:expr xsi:type="sawx:sqlExpression">"HR Position"."Position Code"</sawx:expr></saw:columnFormula></saw:column></saw:columns>    
      <saw:filter>      
         <sawx:expr xsi:type="sawx:logical" op="and">        
            <sawx:expr xsi:type="sawx:list" op="in">          
               <sawx:expr xsi:type="sawx:sqlExpression">Year("Job Requisition - Dates"."Creation Date")</sawx:expr>          
               <sawx:expr xsi:type="sawx:eval" default="%">creation_year</sawx:expr>        </sawx:expr>        
            <sawx:expr xsi:type="sawx:list" op="in">          
               <sawx:expr xsi:type="sawx:sqlExpression">CAST(Year("Job Requisition - Dates"."Creation Date") AS CHAR(4)) || ' Q ' || CAST(Quarter("Job Requisition - Dates"."Creation Date") AS CHAR(1))</sawx:expr>          
               <sawx:expr xsi:type="sawx:eval" default="%">creation_quarter</sawx:expr>        </sawx:expr>        
            <sawx:expr xsi:type="sawx:list" op="in">          
               <sawx:expr xsi:type="sawx:sqlExpression">CAST( Year("Job Requisition - Dates"."Creation Date") AS CHAR(4)) || ' / ' || (CASE WHEN Month("Job Requisition - Dates"."Creation Date") &lt; 10 THEN '0' ELSE '' END) || CAST(Month("Job Requisition - Dates"."Creation Date") AS VARCHAR(2))</sawx:expr>          
               <sawx:expr xsi:type="sawx:eval" default="%">creation_month</sawx:expr>        </sawx:expr>                                                                                                      
            <sawx:expr xsi:type="sawx:comparison" op="greater">
               <sawx:expr xsi:type="sawx:sqlExpression">"Facts - Job Application Counts"."Number of Active Job Applications"</sawx:expr>
               <sawx:expr xsi:type="xsd:decimal">0</sawx:expr></sawx:expr></sawx:expr>    </saw:filter>    
      <saw:columnOrder>      
         <saw:columnOrderRef columnID="cddabc4c8d896b131" direction="descending"/>    </saw:columnOrder>  </saw:criteria>  
   <saw:interactionOptions drill="true" movecolumns="true" sortcolumns="true" addremovevalues="false" groupoperations="false" calcitemoperations="false" showhidesubtotal="false" showhiderunningsum="false" inclexclcolumns="true"/>  
   <saw:views textDelivery="compoundView!1" parentsBefore="true" includeNewColumns="true" nullSuppress="true" currentView="0">    
      <saw:view xsi:type="saw:compoundView" name="compoundView!1">          
         <saw:cvTable>
            <saw:cvRow>
               <saw:cvCell viewName="titleView!1"/></saw:cvRow>
            <saw:cvRow>
               <saw:cvCell viewName="pivotTableView!1"/></saw:cvRow></saw:cvTable></saw:view>    
      <saw:view xsi:type="saw:titleView" name="titleView!1"/>        
      <saw:view xsi:type="saw:noresultsview" name="noresultsview!1">      
         <saw:headline>        
            <saw:caption fmt="text" captionID="kcap1529452914422_70">          
               <saw:text>No results found.</saw:text>        </saw:caption>      </saw:headline>      
         <saw:detail>        
            <saw:caption fmt="text" captionID="kcap1529452914422_71">          
               <saw:text>Check your search criteria.</saw:text>        </saw:caption>      </saw:detail>    </saw:view>  
      <saw:view xsi:type="saw:pivotTableView" name="pivotTableView!1" scrollingEnabled="false">
         <saw:edges>
            <saw:edge axis="page" showColumnHeader="true"/>
            <saw:edge axis="section"/>
            <saw:edge axis="row" showColumnHeader="true">
               <saw:columnOrder>
                  <saw:columnOrderRef columnID="c3c2b37816f3606e0" direction="ascending"/></saw:columnOrder>
               <saw:edgeLayers>
                  <saw:edgeLayer type="column" columnID="c2633b212bd4ef795"/>
                  <saw:edgeLayer type="column" columnID="c3c2b37816f3606e0"/>
                  <saw:edgeLayer type="column" columnID="ce91f632909f0d26d"/>
                  <saw:edgeLayer type="column" columnID="c56f4556a94fb6f7f"/>
                  <saw:edgeLayer type="column" columnID="c08de9310d5ea082b"/></saw:edgeLayers></saw:edge>
            <saw:edge axis="column" showColumnHeader="rollover">
               <saw:edgeLayers>
                  <saw:edgeLayer type="measure"/>
                  <saw:edgeLayer type="column" columnID="c54fdfeaa1b3defad"/></saw:edgeLayers></saw:edge></saw:edges>
         <saw:measuresList>
            <saw:measure columnID="cc373f914af272bad"/></saw:measuresList></saw:view></saw:views></saw:report>