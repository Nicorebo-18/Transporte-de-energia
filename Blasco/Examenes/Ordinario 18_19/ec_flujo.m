%genera el conjunto de ecuaciones para resolver el flujo de cargas
function f = ec_flujo( x ) 
global Tipo u0 d0 p0 q0 n y g %variables conocidas compartidas por este script
u = zeros(n,1);
d = zeros(n,1);
p = zeros(n,1);
q = zeros(n,1);
for k = 1:1:n
    switch Tipo(k)
        case 1
            u(k) = u0(k);
            d(k) = d0(k);
            p(k) = x(2*k-1);
            q(k) = x(2*k);
        case 2
            u(k) = u0(k);
            d(k) = x(2*k-1);
            p(k) = p0(k);
            q(k) = x(2*k);
        case 3
            u(k) = x(2*k-1);
            d(k) = x(2*k);
            p(k) = p0(k);
            q(k) = q0(k);
    end
end

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