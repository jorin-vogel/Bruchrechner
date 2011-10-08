class Fraktioncalculator.Calculation extends Batman.Model

  @persist Batman.LocalStorage

  @encode 'operator', 'denominator1', 'denominator2', 'numerator1', 'numerator2'

  @global yes

  operator: '+'

  @accessor 'showNo_fraktion', ->
    den = @get('denominatorView')
    num = @get('numeratorView')
    den is 0 or num is 0 or num is 1

  @accessor 'noFraktion', ->
    if @get('numeratorResult') is 0
      0
    else
      @get('denominatorResult')

  @accessor 'negative', ->
    den = @get('denominatorResult') >= 0
    num = @get('numeratorResult') >= 0
    den + num is 1

  shortening: no

  denominator1: '1'
  denominator2: '1'

  denominatorOperators:
    '+': ( n1, n2 ,z1 ,z2 )->  
      unless z1 is z2
        n1 * z2 + n2 * z1
      else
        n1 + n2

    '-': ( n1, n2 ,z1 ,z2 )->  
      unless z1 is z2
        n1 * z2 - n2 * z1
      else
        n1 - n2

    'x': (n1, n2) -> n1 * n2
    ':': ( n1, n2 ,z1 ,z2 )-> n1 * z2

  @accessor 'denominatorResult', -> 
    res = @get('denominatorOperators')[@get 'operator']( Number(@get('denominator1')), Number(@get('denominator2')), Number(@get('numerator1')), Number(@get('numerator2')) )

    res or 0

  @accessor 'denominatorView', ->
    den = Math.sqrt( Math.pow( @get('denominatorResult'), 2 ) )
    num = Math.sqrt( Math.pow( @get('numeratorResult'), 2 ) )

    
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



  numerator1: '1'
  numerator2: '1'

  numeratorOperators:
    '+': ( n1, n2, z1, z2 ) ->
      unless z1 is z2
        z1 * z2
      else
        z1
    '-': ( n1, n2, z1, z2 ) ->
      unless z1 is z2
        z1 * z2
      else
        z1
    'x': ( n1, n2, z1, z2 ) -> z1 * z2
    ':': ( n1, n2, z1, z2 ) -> z1 * n2

  @accessor 'numeratorResult', -> 
    res = @get('numeratorOperators')[@get 'operator']( Number(@get('denominator1')), Number(@get('denominator2')), Number(@get('numerator1')), Number(@get('numerator2')) )

    res or 0

  @accessor 'numeratorView', ->
    den = Math.sqrt( Math.pow( @get('denominatorResult'), 2 ) )
    num = Math.sqrt( Math.pow( @get('numeratorResult'), 2 ) )

    
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
