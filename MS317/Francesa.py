import pandas as pd
D = float(input("Digite o valor da dívida inicial: "))
i = float(input("Digite o interesse aplicado a divida, usando valores de 0 a 1: "))
t = int(input("Digite em quanto tempo se pretende quitar a dívida: "))
rt = int(input("Digite em que tempo o valor da parcela pago será diferente do planejado, se não for acontecer, digite 0: "))
v = float(input("Digite qual será o valor da parcela diferente, que acontecerá no tempo rt, se não for ocorrer, digite 0: "))
it = int(input("Digite em que tempo o valor de interesse será alterado, se não for ocorrer, digite 0: "))
vi = float(input("Digite qual será o novo valor do interesse, usando valores de 0 a 1, se não for ocorrer, digite 0: "))
dt = int(input("Digite em que tempo uma nova divida foi contraída, se não ocorrer, digite 0: "))
vd = float(input("Digite o valor da dívida a ser adicionada, ou perdão de dívida (com sinal negativo nesse caso), se não ocorrer, digite 0: "))

def AF(D, i, t, rt, v, it, vi, dt, vd):
  #inicializando a tabela 
  n = 0
  R = -D*i*(i+1)**t/(1-(i+1)**t)
  interesse = ["-"]
  juros = [0]
  Divida = [D]
  Parcela = [0]
  Devolve = [0]
  Devolvet = [0]
  total = 0
  while n < t:
    #As primeira verificações que o algoritmo vai fazer é se existe alguma quota
    #diferente da esperada, uma variação de taxa de interesse ou mudança na dívida. Caso não, ele vai calcular a amortização com base na 
    #quota capital normalmente, e se houver essas mudanças em algum tempo, o programa irá recalcular os valores das parcelas seguintes.
    if (dt - 1 == n) and (dt != 0):
      Divida[n] = Divida[n] + vd
      R = -Divida[n]*i*(i+1)**(t-n)/(1-(i+1)**(t-n))
    if (it - 1 == n) and (it != 0):
      i = vi
      R = -Divida[n]*i*(i+1)**(t-n)/(1-(i+1)**(t-n))
    if (rt - 1 == n) and (rt != 0):
      Parcela.append(v)
    else:
      Parcela.append(R)
    interesse.append(i)
    juros.append(i*Divida[n])
    Devolve.append(Parcela[n+1]-juros[n+1])
    Divida.append(Divida[n]-Devolve[n+1])
    Devolvet.append(Devolvet[n] + Devolve[n+1])
    total = total + Parcela[n]
    if (rt - 1 == n) and (rt != 0):
      R = -Divida[n+1]*i*(i+1)**(t-n-1)/(1-(i+1)**(t-n-1))
    n = n + 1 
  #Ajustando a primeira linha da tabela para a configuração padrão
  Parcela[0] = "-"
  juros[0] = "-"
  Devolve[0] = "-"
  #Imprimir a tabela
  data = {"ik": interesse, "Rk": Parcela, "Ik": juros, "Ck": Devolve, "Dk": Divida, "Ek": Devolvet}
  df = pd.DataFrame(data)
  print(df)
  print("Total pago:", total)

AF(D, i, t, rt, v, it, vi, dt, vd)