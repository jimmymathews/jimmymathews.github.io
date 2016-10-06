-----------------------------------------------------------------------------------
--Contents
--
--SetupTCRLP  sets up tensor coordinate ring and letterplace algebra
--            (must call this yourself to set up letter names and tensor types)
--
-- sample usage of this setup function
--
-- U          umbral operator from letterplace algebra to algebra of tensor
--            coordinate functions
--
-- br         bracket operator from 4-tuples of abstract letters (naming tensors)
--            to the letterplace algebra
--
-- sample usage of U and br
--
-- matrixWRT  forms matrix of given function of tensor coordinates with respect
--            to coordinates of given pair of tensors
--
-- sample usage of matrixWRT
--
-- samples
-----------------------------------------------------------------------------------



-----------------------------------------------------------------------------------
--SetupTCRLP sets:
--
--TCR.......tensor coordinate ring
--LP........letterplace algebra
--
--w1s.......list of names for 1-tensors
--w2s.......list of names for (anti-symmetric) 2-tensors
--w3s.......list of names for (anti-symmetric) 3-tensors

SetupTCRLP=(w1s,w2s,w3s)->(
compactMatrixForm=false;
Ground=QQ;
n1=length w1s;
n2=length w2s;
n3=length w3s;
l1:=flatten for i from 0 to length(w1s)-1 list for j from 1 to 4 list ((w1s)_i)_{j};
l2:=flatten flatten for i from 0 to length(w2s)-1 list for j from 1 to 4 list for k from 1 to 4 list ((w2s)_i)_(j,k);
l3:=flatten flatten flatten for i from 0 to length(w3s)-1 list for j from 1 to 4 list for k from 1 to 4 list for l from 1 to 4 list ((w3s)_i)_(j,k,l);
TCR=Ground[flatten{l1,l2,l3}];
lp1=flatten for i from 0 to length(w1s)-1 list for j from 1 to 4 list (w1s_i)_j;
lp2=flatten for i from 0 to length(w2s)-1 list for j from 1 to 4 list (w2s_i)_j;
lp3=flatten for i from 0 to length(w3s)-1 list for j from 1 to 4 list (w3s_i)_j;
LP=TCR[flatten {lp1,lp2,lp3},SkewCommutative=>true];
m1:=flatten for i from 0 to length(w1s)-1 list for j from 1 to 4 list  sub((vars TCR)_(0,i*4+(j-1)),LP)-(vars LP)_(0,i*4+(j-1));
m2:=flatten flatten for i from 0 to length(w2s)-1 list for j from 1 to 4 list for k from 1 to 4 list sub((vars TCR)_(0,length(l1)+i*16+(j-1)*4+(k-1)),LP)-(vars LP)_(0,length(lp1)+i*4+(j-1))*(vars LP)_(0,length(lp1)+i*4+(k-1));
m3:=flatten flatten flatten for i from 0 to length(w3s)-1 list for j from 1 to 4 list for k from j+1 to 4 list for l from k+1 to 4 list sub((vars TCR)_(0,length(l1)+length(l2)+i*64+16*(l-1)+4*(k-1)+(j-1)),LP)+(vars LP)_(0,length(lp1)+length(lp2)+i*4+(j-1))*(vars LP)_(0,length(lp1)+length(lp2)+i*4+(k-1))*(vars LP)_(0,length(lp1)+length(lp2)+i*4+(l-1));
umbralRelations=ideal(flatten{m1,m2,m3});
);
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
--Sample setup

SetupTCRLP({a},{b,c},{d})

print " "
print "The default setup call is SetupTCRLP({},{c},{a,b}).  This produces a Tensor Coordinate Ring and and LetterPlace algebra capable of handling one vector called a, two 2-extensor called b and c, and one 3-extensors's d.  You may delete this call in the source, and run your own setup call after running the script.  Or, you can edit the source for a different permanent setup."
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
print " "
print "U(inp)                            umbral operator from LP to TCR"

U=(inp)->(
	use LP;
	cc:=coefficients(inp);
	coeffs:=cc_1;
	elts:=cc_0;
	nr:=numRows(coeffs);
	sub(sum for i from 0 to nr-1 list coeffs_(i,0)*sub(elts_(0,i),LP/umbralRelations),TCR)
)
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
print " "
print "br(l1,l2,l3,l4)                   bracket of 4 letters, result in LP"

count=(inlist,elt)->(var=0;for i from 0 to length(inlist)-1 do if (inlist_i)_1==elt_1 then var=var+1;var);

br=(l1,l2,l3,l4)->(
	use LP;
	inp:=(l1,l2,l3,l4);
	setinp:=elements set inp;
	mult:=1;
	for i from 0 to length(setinp)-1 do mult=mult*(count(inp,setinp_i))!;
	sub((gens permanents(4,matrix for i from 1 to 4 list {l1_i,l2_i,l3_i,l4_i}))_(0,0)/mult,LP)
)
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
--Compute desired bracket polynomials and their umbral images as functions on the tensor space, for example:
--br(b,b,c,c)*br(a,d,d,d)
--U(br(b,b,c,c)*br(a,d,d,d))
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
print " "
print "matrixWRT(letter1,letter2,input)  organizes a TCR element as a matrix With Respect To the components of 2 given letter-named tensors"

matrixWRT=(letter1,letter2,input)->(
index1=index letter1_1;
index2=index letter2_1;
if(index1 <  4*n1) then B1=matrix{{(letter1)_{1},(letter1)_{2},(letter1)_{3},(letter1)_{4}}};
if(index1 >= 4*n1 and index1 < 4*(n1+n2)) then B1=matrix{{(letter1)_(2,1),(letter1)_(3,1),(letter1)_(3,2),(letter1)_(4,1),(letter1)_(4,2),(letter1)_(4,3)}};
if(index1 >=4*(n1+n2)) then B1=matrix{{(letter1)_(4,3,2),-1*(letter1)_(4,3,1),(letter1)_(4,2,1),-1*(letter1)_(3,2,1)}};
if(index2 <  4*n1) then B2=matrix{{(letter2)_{1},(letter2)_{2},(letter2)_{3},(letter2)_{4}}};
if(index2 >= 4*n1 and index2 < 4*(n1+n2)) then B2=matrix{{(letter2)_(2,1),(letter2)_(3,1),(letter2)_(3,2),(letter2)_(4,1),(letter2)_(4,2),(letter2)_(4,3)}};
if(index2 >=4*(n1+n2)) then B2=matrix{{(letter2)_(4,3,2),-1*(letter2)_(4,3,1),(letter2)_(4,2,1),-1*(letter2)_(3,2,1)}};
BB=transpose(B1)**B2;
(B1,matrix for i from 0 to numRows(BB)-1 list for j from 0 to numColumns(BB)-1 list sub((input-(input % ideal(BB_(i,j))))/(BB_(i,j)),TCR),transpose(B2))
);
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
--Sample usage of matrixWRT
--matrixWRT(a,d,U(br(a,b,b,c)*br(c,d,d,d)))
--matrixWRT(a,d,U(br(a,b,c,d)*br(b,c,d,d)))
-----------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------
--Samples
--wedge product of two 2-tensors (related to fundamental matrix / essential matrix)
--matrixWRT(b,c,U(br(b,b,c,c)))
--trifocal tensor invariant
--SetupTCRLP({},{a},{c,d})
--matrixWRT(c,d,U(br(a,c,c,c)*br(a,d,d,d)))
-----------------------------------------------------------------------------------------------------

