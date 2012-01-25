class Fractioncalculator.Calculation extends Batman.Model

  #use the default adapter for the localstorage
  @persist Batman.LocalStorage

  #define the attributes we want to persist
  @encode 'operator', 'denominator1', 'denominator2', 'numerator1', 'numerator2'

  #makes the Calculation class accessible in the global namespace
  @global yes

  #current operator
  #used for calculations
  operator: '+'


  @accessor 'showNo_fraction', ->
    #if one part of the fraction is zero
    #or the numerator is 1
    #it is nicer to display the result
    #without fraction
    den = @get('denominatorView')
    num = @get('numeratorView')
    den is 0 or num is 0 or num is 1


  @accessor 'noFraction', ->
    #accesor used when showNo_fraction is true
    if @get('numeratorResult') is 0
      0
    else
      @get('denominatorView')


  @accessor 'negative', ->
    #this part is a bit tricky:
    #we use the type-conversion of javascript
    #which converts true to 1 and false to 0.
    #it results in the same as:
    #(den is true and num is false) or (den is false and num is true)
    den = @get('denominatorResult') >= 0
    num = @get('numeratorResult') >= 0
    den + num is 1


  #default values

  shortening: no

  denominator1: '1'
  denominator2: '1'


#the following is some weird math
#because we have to calculate 
#denominator and numerator seperatly

  
  denominatorOperators:

    '+': ( d1, d2 ,n1 ,n2 )->  
      unless n1 is n2
        d1 * n2 + d2 * n1
      else
        d1 + d2

    '-': ( d1, d2 ,n1 ,n2 )->  
      unless n1 is n2
        d1 * n2 - d2 * n1
      else
        d1 - d2

    'x': (d1, d2) -> d1 * d2

    ':': ( d1, d2 ,n1 ,n2 )-> d1 * n2


  @accessor 'denominatorResult', ->
    res = @get('denominatorOperators')[@get 'operator']( Number(@get('denominator1')), Number(@get('denominator2')), Number(@get('numerator1')), Number(@get('numerator2')) )

    res or 0


  #this one is the denominator displayed in the view
  @accessor 'denominatorView', ->
    #we want to ensure that the algebraic sign is removed
    den = Math.sqrt( Math.pow( @get('denominatorResult'), 2 ) )
    num = Math.sqrt( Math.pow( @get('numeratorResult'), 2 ) )

    #on this way we can find the biggest shared even divisor
    if @get('shortening')
      a = den 
      b = num
      while true
        [a, b] = [b, a % b]
        if b is 0
          return den / a
          break
    else 
      den


  #default values
  numerator1: '1'
  numerator2: '1'


  numeratorOperators:

    '+': ( d1, d2, n1, n2 ) ->
      unless n1 is n2
        n1 * n2
      else
        n1

    '-': ( d1, d2, n1, n2 ) ->
      unless n1 is n2
        n1 * n2
      else
        n1

    'x': ( d1, d2, n1, n2 ) -> n1 * n2

    ':': ( d1, d2, n1, n2 ) -> n1 * d2


  @accessor 'numeratorResult', -> 
    res = @get('numeratorOperators')[@get 'operator']( Number(@get('denominator1')), Number(@get('denominator2')), Number(@get('numerator1')), Number(@get('numerator2')) )

    res or 0


  #this one is the numerator displayed in the view
  @accessor 'numeratorView', ->
    #we want to ensure that the algebraic sign is removed
    den = Math.sqrt( Math.pow( @get('denominatorResult'), 2 ) )
    num = Math.sqrt( Math.pow( @get('numeratorResult'), 2 ) )
    
    #on this way we can find the biggest shared even divisor
    if @get('shortening')
      a = den 
      b = num
      while true
        [a, b] = [b, a % b]
        if b is 0
          return num / a
          break
    else 
      num
