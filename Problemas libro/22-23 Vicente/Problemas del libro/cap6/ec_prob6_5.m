%el conjunto de ecuaciones para resolver el flujo de cargas
function f = ec_prob6_5( x )
global u1 d1 p2 q2 p3 q3 p4 q4 p5 u5 y g
  n=5;%n�mero de nudos
u=[u1 x(3) x(5) x(7) u5];
d=[d1 x(4) x(6) x(8) x(10)];
p=[x(1) p2 p3 p4 p5];
q=[x(2) q2 q3 q4 x(9)];

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

 endfunction
