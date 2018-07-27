################################################################################
#
#  Tools for MeatAxe
#
################################################################################

# Given a matrix M in upper right echelon form and a vector, it returns the
# vector reduced with respect to $M$
#
#function cleanvect!(M::T, v::T) where {T <: MatElem}
#  if iszero(v)
#    return v
#  end
#  R = base_ring(M)
#  t = R()
#  for i = 1:rows(M)
#    ind = 1
#    a = M[i, ind]
#    while iszero(a)
#      ind += 1
#      if ind > cols(M)
#        # I found a zero row
#        return v
#      end
#      a = M[i, ind]
#    end
#    b = v[1, ind]
#    if iszero(b)
#      continue
#    end
#    mult = divexact(b, a)
#    v[1, ind] = zero(R)
#    for k in (ind + 1):cols(M)
#      t = mul!(t, mult, M[i, k])
#      s = v[1, k]
#      v[1, k] = sub!(s, s, t)
#      #w[1,k]-= mult*M[i,k]
#    end      
#  end
#  return v
#end
#
#function cleanvect(M::T, v::T) where {T <: MatElem}
#  @assert rows(v) == 1
#  w = deepcopy(v)
#  cleanvect!(M, w)
#  return w
#end
#
## Given a matrix C containing the coordinates of vectors v_1,dots, v_k 
## in echelon form, the function computes a basis for the submodule they generate
## 
## This function destroys the input C
#function closure(C::T, G::Array{T,1}) where {T <: MatElem}
#  rref!(C)
#  w = zero_matrix(base_ring(C), 1, cols(C))
#  CC = zero_matrix(base_ring(C), cols(C), cols(C))
#  for i in 1:rows(C)
#    for j in 1:cols(C)
#      CC[i, j] = C[i, j]
#    end
#  end
#  zero_row = rows(C) + 1
#  i = 1
#  while i <= zero_row - 1
#    for j in 1:cols(C)
#      w[1, j] = CC[i, j]
#    end
#    for j=1:length(G)
#      w = mul!(w, w, G[j])
#      w = cleanvect!(CC, w)
#      if !iszero(w)
#        for k in 1:cols(C)
#          CC[zero_row, k] = w[1, k]
#        end
#        zero_row = zero_row + 1
#        if zero_row > rows(CC) + 1
#          i = zero_row
#          break
#        end
#      end 
#      #w = zero!(w)
#      for j in 1:cols(C)
#        w[1, j] = CC[i, j]
#      end
#    end  
#    i = i + 1
#  end
#  l = rows(CC)
#  r = rref!(CC)
#  # I don't want to make so many copies
#  if r == rows(C)
#    return C
#  elseif l > r
#    return sub(CC, 1:r, 1:cols(CC))
#  else
#    return CC
#  end
#end
#
## Given a matrix C containing the coordinates of one vector
## the function computes a basis for the submodule it generates
## C must not be modified and C does not need to be in rref
#
## I do not understand why my version does not work!
## Must the output contain C at the top?
## TODO: Ask Carlo
#function spinning(C::T, G::Array{T, 1}) where {T <: MatElem}
#  B = deepcopy(C)
#  B = closure(B, G)
#  if rref(B) != rref(_spinning(C, G))
#    @show B
#    @show _spinning(C, G)
#  end
#  return _spinning(C, G)
#  #return B
#end
#
#function _spinning(C::T,G::Vector{T}) where {T <: MatElem}
#  B=deepcopy(C)
#  X=rref(C)[2]
#  i=1
#  while i != rows(B)+1
#    for j=1:length(G)
#      #@show sub(B, i:i, 1:cols(B)) 
#      #@show G[j]
#      el= sub(B, i:i, 1:cols(B)) * G[j]
#      #@show el
#      res= cleanvect(X,el)
#      if !iszero(res)
#        X=vcat(X,res)
#        rref!(X)
#        B=vcat(B,el)
#        if rows(B)==cols(B)
#          return B
#        end
#      end
#    end  
#    i+=1
#  end
#  return B
#end

#  Restriction of the action to the submodule generated by C and the quotient

function __split(C::T, G::Vector{T}) where {T <: MatElem}
# I am assuming that C defines an submodule
  equot=Vector{T}(length(G))
  esub=Vector{T}(length(G))
  pivotindex=Set{Int}()
  for i = 1:rows(C)
    if iszero_row(C,i)
      continue
    end
    ind = 1
    while iszero(C[i, ind])
      ind += 1
    end
    push!(pivotindex, ind)   
  end
  for a = 1:length(G)
    subm, vec=clean_and_quotient(C, C*G[a], pivotindex)
    esub[a] = subm
    s = zero_matrix(base_ring(C),cols(G[1]) - length(pivotindex), cols(G[1]) - length(pivotindex))
    pos = 0
    for i= 1:rows(G[1])
      if !(i in pivotindex)
        m, vec= clean_and_quotient(C, sub(G[a], i:i, 1:rows(G[1])), pivotindex)
        for j=1:cols(vec)
          s[i - pos,j] = vec[1, j]
        end
      else 
        pos += 1
      end
    end
    equot[a] = s
  end
  return ModAlgAss(esub), ModAlgAss(equot), pivotindex
end

#  Restriction of the action to the submodule generated by C
function _actsub(C::T, G::Vector{T}) where {T <: MatElem}
  esub = Vector{T}(length(G))
  pivotindex = Set{Int}()
  for i=1:rows(C)
    ind = 1
    while iszero(C[i, ind])
      ind += 1
    end
    push!(pivotindex, ind)   
  end
  for a=1:length(G)
    subm, vec = clean_and_quotient(C, C*G[a], pivotindex)
    esub[a] = subm
  end
  return ModAlgAss(esub)
  #return ModAlgAss(esub)
end

#  Restriction of the action to the quotient by the submodule generated by C
function _actquo(C::T,G::Vector{T}) where {T <: MatElem}
  equot = Vector{T}(length(G))
  pivotindex = Set{Int}()
  for i=1:rows(C)
    ind = 1
    while iszero(C[i,ind])
      ind += 1
    end
    push!(pivotindex,ind)   
  end
  for a=1:length(G)
    s = zero_matrix(base_ring(C), cols(G[1]) - length(pivotindex), cols(G[1]) - length(pivotindex))
    pos = 0
    for i=1:rows(G[1])
      if !(i in pivotindex)
        m, vec = clean_and_quotient(C, sub(G[a],i:i,1:rows(G[1])), pivotindex)
        for j=1:cols(vec)
          s[i - pos, j]=vec[1, j]
        end
      else 
        pos += 1
      end
    end
    equot[a] = s
  end
  return ModAlgAss(equot), pivotindex
end

#
#  Function that determine if two modules are isomorphic, provided that the first is irreducible
#
function isisomorphic(M::ModAlgAss{S, T}, N::ModAlgAss{S, T}) where {S, T}
  @assert M.isirreducible == 1
  @assert base_ring(M) == base_ring(N)
  @assert length(M.action) == length(N.action)
  if dimension(M) != dimension(N)
    return false
  end

  if M.dimension==1
    return M.action==N.action
  end

  K= base_ring(M)
  Kx,x=PolynomialRing(K, "x", cached=false)
  
  if length(M.action) == 1
    f=charpoly(Kx,M.action[1])
    g=charpoly(Kx,N.action[1])
    if f==g
      return true
    else
      return false
    end
  end
  
  n=M.dimension
  posfac=n
   
  f=Kx(1)
  G=deepcopy(M.action)
  H=deepcopy(N.action)

  rel = _relations(M,N)
  return iszero(rel[N.dimension, N.dimension])

  #=
  
  #
  #  Adding generators to obtain randomness
  #
  
  for i=1:max(length(M.action),9)
    l1=rand(1:length(G))
    l2=rand(1:length(G))
    while l1 !=l2
      l2=rand(1:length(G))
    end
    push!(G, G[l1]*G[l2])
    push!(H, H[l1]*H[l2])
  end

  #
  #  Now, we get peakwords
  #
  
  A=zero_matrix(K,n,n)
  B=zero_matrix(K,n,n)
  found=false
  
  while !found
  
    A=zero_matrix(K,n,n)
    B=zero_matrix(K,n,n)
    l1=rand(1:length(G))
    l2=rand(1:length(G))
    push!(G, G[l1]*G[l2])
    push!(H, H[l1]*H[l2])
  
    for i=1:length(G)
      s=rand(K)
      A+=s*G[i]
      B+=s*H[i]
    end
  
    cp=charpoly(Kx,A)
    cpB=charpoly(Kx,B)
    if cp!=cpB
      return false
    end
    sq=prod(collect(keys(factor_squarefree(cp).fac)))
    j=1
    while !isone(sq)
      g=gcd(x^(Int(order(K)^j))-x,sq)
      sq=divexact(sq,g)
      lf=factor(g)
      for t in keys(lf.fac)
        f=t
        S=_subst(t,A)
        a,kerA=nullspace(transpose(S))
        if a==1
          M.dim_spl_fld=1
          found=true
          break
        end
        kerA=transpose(kerA)
        posfac=gcd(posfac,a) 
        if divisible(fmpz(posfac),a)
          v=sub(kerA, 1:1, 1:n)
          U=v
          T =spinning(v,G)
          G1=[T*mat*inv(T) for mat in M.action]
          i=2
          E=fq_nmod_mat[eye(T,a)]
          while rows(U)!= a
            w= sub(kerA, i:i, 1:n)
            z= cleanvect(U,w)
            if iszero(z)
              continue
            end
            O =spinning(w,G)
            G2=[O*mat*inv(O) for mat in M.action]
            if G1 == G2
              b=kerA*O
              x=transpose(solve(transpose(kerA),transpose(b)))
              push!(E,x)
              U=vcat(U,z)
              U=closure(U,E)
            else 
              break
            end
            if rows(U)==a
              M.dim_spl_fld=a
              found=true
              break
            else
              i+=1
            end
          end
        end
        if found==true
          break
        end
      end   
      j+=1        
    end
  end
  #
  #  Get the standard basis
  #

  
  L=_subst(f,A)
  a,kerA=nullspace(transpose(L))
  
  I=_subst(f,B)
  b,kerB=nullspace(transpose(I))


  if a!=b
    return false
  end
  
  Q= spinning(transpose(sub(kerA, 1:n, 1:1)), M.action)
  W= spinning(transpose(sub(kerB, 1:n, 1:1)), N.action)
  
  #
  #  Check if the actions are conjugated
  #
  S=inv(W)*Q
  T=inv(S)
  for i=1:length(M.action)
    if S*M.action[i]* T != N.action[i]
      return false
    end
  end
  return true

  =#
end

function _enum_el(K,v,dim)
  if dim == 0
    return [v]
  else 
    list=[]
    push!(v,K(0))
    for x in K 
      v[length(v)]=x
      push!(list,deepcopy(v))
    end
    list1=[]
    for x in list
      append!(list1,_enum_el(K,x, dim-1))
    end
    return list1
  end
end

function dual_space(M::ModAlgAss{S, T}) where {S, T}
  G=T[transpose(g) for g in M.action]
  return ModAlgAss(G)
end

function _subst(f::Nemo.PolyElem{T}, a::S) where {T <: Nemo.RingElement, S}
   #S = parent(a)
   n = degree(f)
   if n < 0
      return similar(a)#S()
   elseif n == 0
      return coeff(f, 0)*eye(a)
   elseif n == 1
      return coeff(f, 0)*eye(a) + coeff(f, 1)*a
   end
   d1 = isqrt(n)
   d = div(n, d1)
   A = powers(a, d)
   s = coeff(f, d1*d)*A[1]
   for j = 1:min(n - d1*d, d - 1)
      c = coeff(f, d1*d + j)
      if !iszero(c)
         s += c*A[j + 1]
      end
   end
   for i = 1:d1
      s *= A[d + 1]
      s += coeff(f, (d1 - i)*d)*A[1]
      for j = 1:min(n - (d1 - i)*d, d - 1)
         c = coeff(f, (d1 - i)*d + j)
         if !iszero(c)
            s += c*A[j + 1]
         end
      end
   end
   return s
end

#################################################################
#
#  MeatAxe, Composition Factors and Composition Series
#
#################################################################



doc"""
***
    meataxe(M::FqGModule) -> Bool, MatElem

> Given module M, returns true if the module is irreducible (and the identity matrix) and false if the space is reducible, togheter with a basis of a submodule

"""

function meataxe(M::ModAlgAss{S, T}) where {S, T}
  K=base_ring(M)
  Kx,x=PolynomialRing( K,"x", cached=false)
  n=dimension(M)
  H=M.action
  if n == 1
    M.isirreducible=1
    return true, eye(H[1], n)
  end
  
  if length(H)==1
    A=H[1]
    poly=charpoly(Kx,A)
    sq=factor_squarefree(poly)
    lf=factor(first(keys(sq.fac)))
    t=first(keys(lf.fac))
    if degree(t)==n
      M.isirreducible= 1
      return true, eye(H[1],n)
    else 
      N= _subst(t, A)
      Ntrnull = nullspace(transpose(N))
      # TODO: Remove this once fixed.
      if isa(Ntrnull[1], T)
        kern=transpose(Ntrnull[1])
      else
        kern=transpose(Ntrnull[2])
      end
      #kern=transpose(nullspace(transpose(N))[2])
      #@show nullspace(transpose(N))
      #@show kern
      B=closure(sub(kern,1:1, 1:n),H)
      return false, B
    end
  end
  
  #
  #  Adding generators to obtain randomness
  #
  G=deepcopy(H)
  Gt=T[transpose(x) for x in M.action]
  
  for i=1:max(length(M.action),9)
    l1=rand(1:length(G))
    l2=rand(1:length(G))
    while l1 !=l2
      l2=rand(1:length(G))
    end
    push!(G, G[l1]*G[l2])
  end
  
  
  while true
  
  # At every step, we add a generator to the group.
  
    push!(G, G[rand(1:length(G))]*G[rand(1:length(G))])
    
  #
  # Choose a random combination of the actual generators of G
  #
    A=zero_matrix(K,n,n)
    for i=1:length(G)
      A+=rand(K)*G[i]
    end
 
  #
  # Compute the characteristic polynomial and, for irreducible factor f, try the Norton test
  # 
    poly=charpoly(Kx,A)
    sqfpart=keys(factor_squarefree(poly).fac)
    for el in sqfpart
      sq=el
      i=1
      while !isone(sq)
        f=gcd(powmod(x, order(K)^i, sq)-x,sq)
        sq=divexact(sq,f)
        lf=factor(f)
        for t in keys(lf.fac)
          N = _subst(t, A)
          # TODO: Remove this once fixed.
          a,kern=nullspace(transpose(N))
          if kern isa Int
            a, kern = kern, a
          end
          #
          #  Norton test
          #   
          B=closure(transpose(sub(kern,1:n, 1:1)),M.action)
          if rows(B)!=n
            M.isirreducible= 2
            return false, B
          end
          # TODO: Remove this
          aa, kernt=nullspace(N)
          if kernt isa Int
            aa, kernt = kernt, aa
          end
          Bt=closure(transpose(sub(kernt,1:n,1:1)),Gt)
          if rows(Bt)!=n
            Btnu, aa = nullspace(Bt)
            if Btnu isa Int
              Btnu, aa = aa, Btnu
            end
            subst=transpose(Btnu)
            #@assert rows(subst)==rows(closure(subst,G))
            M.isirreducible = 2
            return false, subst
          end
          if degree(t)==a
            #
            # f is a good factor, irreducibility!
            #
            M.isirreducible= 1
            return true, eye(G[1],n)
          end
        end
        i+=1
      end
    end
  end
end

doc"""
***
    composition_series(M::FqGModule) -> Array{MatElem,1}

> Given a Fq[G]-module M, it returns a composition series for M, i.e. a sequence of submodules such that the quotient of two consecutive element is irreducible.

"""

function composition_series(M::ModAlgAss{S, T}) where {S, T}

  if M.isirreducible == 1
    return [eye(M.action[1],M.dimension)]
  end

  bool, C = meataxe(M)
  #
  #  If the module is irreducible, we return a basis of the space
  #
  if bool == true
    return [eye(M.action[1],M.dimension)]
  end
  #
  #  The module is reducible, so we call the algorithm on the quotient and on the subgroup
  #
  G=M.action
  K=M.base_ring
  
  rref!(C)
  
  esub,equot,pivotindex=__split(C,G)
  sub_list = composition_series(esub)
  quot_list = composition_series(equot)
  #
  #  Now, we have to write the submodules of the quotient and of the submodule in terms of our basis
  #
  list=Vector{T}(length(sub_list)+length(quot_list))
  for i=1:length(sub_list)
    list[i]=sub_list[i]*C
  end
  for z=1:length(quot_list)
    s=zero_matrix(K,rows(quot_list[z]), cols(C))
    for i=1:rows(quot_list[z])
      pos=0
      for j=1:cols(C)
        if j in pivotindex
          pos+=1
        else
          s[i,j]=quot_list[z][i,j-pos]
        end
      end
    end
    list[length(sub_list)+z]=vcat(C,s)
  end
  return list
end

doc"""
***
    composition_factors(M::FqGModule)

> Given a Fq[G]-module M, it returns, up to isomorphism, the composition factors of M with their multiplicity,
> i.e. the isomorphism classes of modules appearing in a composition series of M

"""

function composition_factors(M::ModAlgAss{S, T}; dimension::Int=-1) where {S, T}
  
  if M.isirreducible == 1
    if dimension!= -1 
      if M.dimension==dimension
        return Tuple{ModAlgAss{S, T}, Int}[(M,1)]
      else
        return Tuple{ModAlgAss{S, T}, Int}[]
      end
    else
      return Tuple{ModAlgAss{S, T}, Int}[(M,1)]
    end
  end 
 
  K=M.base_ring
  
  bool, C = meataxe(M)
  #
  #  If the module is irreducible, we just return a basis of the space
  #
  if bool
    if dimension!= -1 
      if M.dimension==dimension
        return Tuple{ModAlgAss{S, T}, Int}[(M,1)]
      else
        return Tuple{ModAlgAss{S, T}, Int}[]
      end
    else
      return Tuple{ModAlgAss{S, T}, Int}[(M,1)]
    end
  end
  G=M.action
  #
  #  The module is reducible, so we call the algorithm on the quotient and on the subgroup
  #
  
  rref!(C)
  
  sub,quot,pivotindex=__split(C,G)
  sub_list = composition_factors(sub)
  quot_list = composition_factors(quot)
  #
  #  Now, we check if the factors are isomorphic
  #

  for i=1:length(sub_list)
    for j=1:length(quot_list)
      if isisomorphic(sub_list[i][1], quot_list[j][1])
        sub_list[i]=(sub_list[i][1], sub_list[i][2]+quot_list[j][2])
        deleteat!(quot_list,j)
        break
      end    
    end
  end
  return append!(sub_list, quot_list) 
  #=
  for i=1:length(sub_list)
    for j=1:length(quot_list)
      if isisomorphic(sub_list[i][1], quot_list[j][1])
        sub_list[i][2]+=quot_list[j][2]
        deleteat!(quot_list,j)
        break
      end    
    end
  end
  return append!(sub_list,quot_list)
  =#
end

function _relations(M::ModAlgAss{S, T}, N::ModAlgAss{S, T}) where {S, T}
  @assert M.isirreducible == 1
  G=M.action
  H=N.action
  K=base_ring(M)
  n=dimension(M)
  
  sys=zero_matrix(K,2*dimension(N),dimension(N))
  matrices=T[]
  first=true
  B=zero_matrix(K,1,dimension(M))
  B[1,1]=K(1)
  X=B
  push!(matrices, eye(B,dimension(N)))
  i=1
  while i<=rows(B)
    w=sub(B, i:i, 1:n)
    for j=1:length(G)
      v=w*G[j]
      res=cleanvect(X,v)
      if !iszero(res)
        X=rref(vcat(X,v))[2]
        B=vcat(B,v)
        push!(matrices, matrices[i]*H[j])
      else
        x=_solve_unique(transpose(v),transpose(B))
        A=sum([x[q,1]*matrices[q] for q=1:rows(x)])
        A=A-(matrices[i]*H[j])
        if first
          for s=1:N.dimension
            for t=1:N.dimension
              sys[s,t]=A[t,s]
            end
          end
          first=false
        else
          for s=1:N.dimension
            for t=1:N.dimension
              sys[N.dimension+s,t]=A[t,s]
            end
          end
        end
        rref!(sys)
      end
    end
    if sys[N.dimension,N.dimension]!=0
      break
    end
    i=i+1
  end
  return sys
end

function _irrsubs(M::ModAlgAss{S, T}, N::ModAlgAss{S, T}) where {S, T}

  @assert M.isirreducible == 1
  
  K=M.base_ring
  rel=_relations(M,N)
  if rel[N.dimension, N.dimension]!=0
    return T[]
  end
  a,kern=nullspace(rel)
  # TODO: Remove this once fixed.
  if !(kern isa T)
    a, kern = kern, a
  end
  kern=transpose(kern)
  if a==1
    return T[closure(kern, N.action)]
  end  
  #
  #  Reduce the number of homomorphism to try by considering the action of G on the homomorphisms
  #
  vects=T[sub(kern, i:i, 1:N.dimension) for i=1:a]
  i=1
  while i<length(vects)
    X=closure(vects[i],N.action)
    j=i+1
    while j<= length(vects)
      if iszero(cleanvect(X,vects[j]))
        deleteat!(vects,j)
      else
        j+=1
      end
    end
    i+=1
  end
  if length(vects)==1
    return T[closure(vects[1], N.action)]
  end
  
  #
  #  Try all the possibilities. (A recursive approach? I don't know if it is a smart idea...)
  #  Notice that we eliminate lots of candidates considering the action of the group on the homomorphisms space
  #
  candidate_comb=append!(_enum_el(K,[K(0)], length(vects)-1),_enum_el(K,[K(1)],length(vects)-1))
  deleteat!(candidate_comb,1)
  list=Array{T,1}(length(candidate_comb))
  for j=1:length(candidate_comb)
    list[j] = sum([candidate_comb[j][i]*vects[i] for i=1:length(vects)])
  end
  final_list=T[]
  push!(final_list, closure(list[1], N.action))
  for i = 2:length(list)
    reduce=true
    for j=1:length(final_list)      
      w=cleanvect(final_list[j],list[i])
      if iszero(w)
        reduce=false
        break
      end
    end  
    if reduce
      push!(final_list, closure(list[i],N.action))
    end
  end
  return final_list

end

doc"""
***
    minimal_submodules(M::FqGModule)

> Given a Fq[G]-module M, it returns all the minimal submodules of M

"""


function minimal_submodules(M::ModAlgAss{S, T}, dim::Int=M.dimension+1, lf=[]) where {S, T}
  
  K=M.base_ring
  n=M.dimension
  
  if M.isirreducible==true
    return T[]
  end

  list=T[]
  if isempty(lf)
    lf=composition_factors(M)
  end
  if length(lf)==1 && lf[1][2]==1
    return T[]
  end
  if dim!=n+1
    lf=[x for x in lf if x[1].dimension==dim]
  end
  if isempty(lf)
    return list
  end
  G=M.action
  for x in lf
    append!(list,Hecke._irrsubs(x[1],M)) 
  end
  return list
end


doc"""
***
    maximal_submodules(M::FqGModule)

> Given a $G$-module $M$, it returns all the maximal submodules of M

"""

function maximal_submodules(M::ModAlgAss{S, T}, index::Int=M.dimension, lf=[]) where {S, T}

  M_dual=dual_space(M)
  minlist=minimal_submodules(M_dual, index+1, lf)
  maxlist=Array{T,1}(length(minlist))
  for j=1:length(minlist)
    maxlist[j]=transpose(nullspace(minlist[j])[2])
  end
  return maxlist

end

doc"""
***
    submodules(M::FqGModule)

> Given a $G$-module $M$, it returns all the submodules of M

"""

function submodules(M::ModAlgAss{S, T}) where {S, T}

  K=M.base_ring
  list=T[]
  lf=composition_factors(M)
  minlist=minimal_submodules(M, M.dimension+1, lf)
  for x in minlist
    rref!(x)
    N, pivotindex =_actquo(x,M.action)
    ls=submodules(N)
    for a in ls
      s=zero_matrix(K,rows(a), M.dimension)
      for t=1:rows(a)
        pos=0
        for j=1:M.dimension
          if j in pivotindex
            pos+=1
          else
            s[t,j]=a[t,j-pos]
          end
        end
      end
      push!(list,vcat(x,s))
    end
  end
  for x in list
    rref!(x)
  end
  i=2
  while i<length(list)
    j=i+1
    while j<=length(list)
      if rows(list[j])!=rows(list[i])
        j+=1
      elseif list[j]==list[i]
        deleteat!(list, j)
      else 
        j+=1
      end
    end
    i+=1
  end
  append!(list,minlist)
  push!(list, zero_matrix(K, 0, M.dimension))
  push!(list, identity_matrix(K, M.dimension))
  return list
  
end

doc"""
***
    submodules(M::FqGModule, index::Int)

> Given a $G$-module $M$, it returns all the submodules of M of index q^index, where q is the order of the field

"""

function submodules(M::ModAlgAss{S, T}, index::Int; comp_factors=Tuple{ModAlgAss{S, T}, Int}[]) where {S, T}
  
  K=M.base_ring
  if index==M.dimension
    return T[zero_matrix(K,1,M.dimension)]
  end
  list=T[]
  if index>= M.dimension/2
    if index== M.dimension -1
      if isempty(comp_factors)
        lf=composition_factors(M, dimension=1)
      else
        lf=comp_factors
      end
      list=minimal_submodules(M,1,lf)
      return list
    end
    if isempty(comp_factors)
      lf=composition_factors(M)
    else 
      lf=comp_factors
    end
    for i=1: M.dimension-index-1
      minlist=minimal_submodules(M,i,lf)
      for x in minlist
        N, pivotindex= _actquo(x, M.action)
        #
        #  Recover the composition factors of the quotient
        #
        Sub=_actsub(x, M.action)
        lf1=[(x[1], x[2]) for x in lf]
        for j=1:length(lf1)
          if isisomorphic(lf1[j][1], Sub)
            if lf1[j][2]==1
              deleteat!(lf1,j)
            else
              lf1[j]=(lf1[j][1], lf1[j][2]-1)
            end
            break
          end
        end
        #
        #  Recursively ask for submodules and write their bases in terms of the given set of generators
        #
        ls=submodules(N,index, comp_factors=lf1)
        for a in ls
          s=zero_matrix(K,rows(a)+rows(x), M.dimension)
          for t=1:rows(a)
            pos=0
            for j=1:M.dimension
              if j in pivotindex
               pos+=1
             else
               s[t,j]=a[t,j-pos]
              end
            end
          end
          for t=rows(a)+1:rows(s)
            for j=1:cols(s)
              s[t,j]=x[t-rows(a),j]
            end
          end
          push!(list,s)
        end
      end
    end
   
  #
  #  Eliminating repeatitions
  #

    for x in list
      rref!(x)
    end
    i=1
    while i<=length(list)
      k=i+1
      while k<=length(list)
        if list[i]==list[k]
          deleteat!(list, k)
        else 
          k+=1
        end
      end
      i+=1
    end
    append!(list,minimal_submodules(M,M.dimension-index, lf))
  else 
  #
  #  Duality
  # 
    M_dual=dual_space(M)
    dlist=submodules(M_dual, M.dimension-index)
    list=T[transpose(nullspace(x)[2]) for x in dlist]
  end 
  return list
    
end

## Make Nmod iteratible

Base.start(R::NmodRing) = zero(UInt)

Base.next(R::NmodRing, state::UInt) = (R(state), state + 1)

Base.done(R::NmodRing, state::UInt) = state >= R.n

Base.eltype(::Type{NmodRing}) = nmod

Base.length(R::NmodRing) = R.n

function powmod(f::nmod_poly, e::fmpz, g::nmod_poly)
  if nbits(e) <= 63
    return powmod(f, Int(e), g)
  else
    error("Not implemented yet")
  end
end
