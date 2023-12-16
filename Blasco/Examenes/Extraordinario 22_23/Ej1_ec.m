%genera el conjunto de ecuaciones para resolver el flujo de cargas
function f = Ej1_ec(x) 
global u1 d1 p2 q2 u3 p3 y g %variables conocidas compartidas por este script
  n=3;%número de nudos
u=[u1 x(3) u3]; %módulos de las tensiones
d=[d1 x(4) x(6)]; %argumentos de las tensiones
p=[x(1) p2 p3]; %potencias activas inyectadas
q=[x(2) q2 x(5)]; %potencias reactivas inyectadas

  f(2*n)=0;
  for h=1:n                       
      sumap=0;                    % Resetea variable a cero
      sumaq=0;                    % Resetea variable a cero
      for k=1:n
          sumap = sumap + (u(k)*y(h,k)*cos(d(h)-d(k)-g(h,k)));  
          sumaq = sumaq + (u(k)*y(h,k)*sin(d(h)-d(k)-g(h,k))); 
      end
      f(h)  =u(h)*sumap - p(h);   % ecuaciones de potencia activa
      f(h+n)=u(h)*sumaq - q(h);   % ecuaciones de potencia reactiva   
  end
  
end