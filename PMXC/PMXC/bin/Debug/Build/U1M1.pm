/* Project     : U1M1
   Description : 
*/

type

 CurrentLanguageType : ["{CurrentLanguageType}N/A"
];

variable

  public  B1 : boolean;
  public  I1 : integer;
  public  CurrentLanguage : CurrentLanguageType;

rule

#line 1 "#modeler <U1M1> relation B1I1"
/* : B1I1 (Relation) */
(((true and (B1 = false)) and (I1 = 0)) or ((true and (B1 = true)) and (I1
 = 100)));

