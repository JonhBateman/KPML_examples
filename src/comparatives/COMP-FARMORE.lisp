(in-package :kpml-ex)

;(EXAMPLE
;    :NAME   COMP-FARMORE
;    :GENERATEDFORM   "The month was far warmer than average."
;    :TARGETFORM   "The month was far warmer than average."
;    :LOGICALFORM   
;(C / GREATER-THAN-COMPARISON :TENSE PAST :DOMAIN
;   (M / ONE-OR-TWO-D-TIME :LEX MONTH :DETERMINER THE)
;   :RANGE
;   (W / SENSE-AND-MEASURE-QUALITY :LEX WARM :COMPARISON-MODIFICATION-Q
;      (W C)
;      MODIFICATION :DEGREE-OF-MODIFICATION-Q
;      (W C)
;      HIGH)
;   :STANDARD
;   (A / QUALITY :LEX AVERAGE :DETERMINER ZERO))
;    :SET-NAME   COMPARATIVES
;)

(EXAMPLE
    :NAME   COMP-FARMORE
    :SET-NAME   COMPARATIVES
    :GENERATEDFORM   "The month was far warmer than average ."
    :TARGETFORM   "The month was far warmer than average."
    :LOGICALFORM   
      (L / |GreaterThanComparison|
             :LEX BE
             :TENSE PAST
             :EXCEED-Q EXCEED

             :|domain|
               (M / |OneOrTwoDTime|
                      :LEX MONTH
                      :DETERMINER THE)
             :|standard|
               (A / |GUMThing|
                      :LEX AVERAGE
                      :DETERMINER ZERO)
             :|range|
               (C / |SenseANDMeasureQuality|
                      :COMPARISON-MODIFICATION-Q (C L) MODIFICATION
                      :DEGREE-OF-MODIFICATION-Q (C L) HIGH
                      :LEX WARM))
)
