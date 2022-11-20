import pandas as pd
D = float(input("Digite o valor da dívida inicial: "))
i = float(input("Digite o interesse aplicado a divida, usando valores de 0 a 1: "))
t = int(input("Digite em quanto tempo se pretende quitar a dívida: "))
rt = int(input("Digite em que tempo o valor da parcela pago será diferente do planejado, se não for acontecer, digite 0: "))
v = float(input("Digite qual será o valor da parcela diferente, que acontecerá no tempo rt, se não for ocorrer, digite 0: 1"))

def AF(D, i, t, rt, v):
  #inicializando a tabela 
  n = 0
  R = [0]
  interesse = ["-"]
  juros = [0]
  Divida = [D]
  Parcela = [0]
  Devolve = [0]
  Devolvet = [0]
  total = 0

  while n < t:
    #a primeira verificação que o algoritmo vai fazer é se existe alguma quota
    #diferente da esperada, caso sim, ele vai calcular a amortização com base na 
    #quota capital
    if (rt == n+1) and (rt!=0):
        juros.append(i*Divida[n])
        Devolve.append(v-juros[n+1])
        Divida.append(Divida[n]-Devolve[n+1])
        Devolvet.append(D-Divida[n+1])
        Parcela.append(v)
        interesse.append(i)
    #Caso contrário, ele calcula a quota capital com base na amortização
    else:
        Devolve.append(Divida[n]/(t-n))
        Divida.append(Divida[n]-Devolve[n+1])
        Devolvet.append(D-Divida[n+1])
        interesse.append(i)
        juros.append(i*Divida[n])
        Parcela.append(Devolve[n+1]+juros[n+1])
    total = total + Parcela[n+1]
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

AF(D, i, t, rt, v)