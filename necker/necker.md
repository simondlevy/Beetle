# The Necker Cube in VSA

<img src="necker-cube.png" height=200>

In our <b>Necker Cube</b> program, the candidate solution state <i>x</i>
is initially just the vector sum of the representations of all possible 
solution components:


<i>x</i><sub>0</sub> = <i>P<sub>f</sub> + Q<sub>f</sub> + R<sub>f</sub> +  
S<sub>f</sub> + T<sub>b</sub> + U<sub>b</sub> + V<sub>b</sub> + W<sub>b</sub>  + 
P<sub>b</sub> + Q<sub>b</sub> + R<sub>b</sub> + S<sub>b</sub> + T<sub>f</sub> + 
U<sub>f</sub> + V<sub>f</sub> + W<sub>f</sub></i>

where the subscripts stand for <i>f</i>orward and <i>b</i>ackward.
As usual for VSA, each term of the sum is a vector of high dimensionality with 
elements chosen randomlyfrom the set {-1,+1}. The constraints (evidence) <i>w</i> 
can then be represented as the sum of the pairwise products of  
mutually-consistent components:

<i>w = P<sub>f</sub> &otimes;Q<sub>f</sub>  + P<sub>f</sub> &otimes;R<sub>f</sub>  + 
P<sub>f</sub> &otimes;S<sub>f</sub>  +
P<sub>f</sub> &otimes;T<sub>b</sub> + 
P<sub>f</sub> &otimes; U<sub>b</sub> + ... + W<sub>b</sub>&otimes;P<sub>f</sub> + 
W<sub>b</sub>&otimes;Q<sub>f</sub>  + ... + W<sub>b</sub>&otimes;U<sub>b</sub> + 
W<sub>b</sub>&otimes;V<sub>b</sub></i>  
<p>
The update of <i>x</i> from <i>w</i> can likewise be implemented by using the binding 
(elementwise product) operator &otimes;.  If any vertex/position vector 
(e.g. <i>P<sub>f</sub></i>)
has greater 
representation in <i>x</i> than others do, multiplying this consistency vector <i>w</i> by the 
state vector <i>x</i> has the effect of &ldquo;unlocking&rdquo;  (unbinding) the components of <i>w</i> 
consistent with this evidence.  As an example, consider the extreme case in 
which <i>x</i> contains only the component <i>P<sub>f</sub></i>:

<i>x<sub>t</sub>&otimes;w=<br>
P<sub>f</sub>  &otimes;(P<sub>f</sub> &otimes;Q<sub>f</sub>  + 
P<sub>f</sub> &otimes;R<sub>f</sub>  + P<sub>f</sub> &otimes;S<sub>f</sub>  + 
P<sub>f</sub> &otimes;T<sub>b</sub> + P<sub>f</sub> &otimes;U<sub>b</sub> + 
... + W<sub>b</sub>&otimes;P<sub>f</sub>  + W<sub>b</sub>&otimes;Q<sub>f</sub>  + 
... +W<sub>b</sub>&otimes;U<sub>b</sub> + W<sub>b</sub>&otimes;V<sub>b</sub>) =<br>
Q<sub>f</sub>  + R<sub>f</sub>  + S<sub>f</sub>  + T<sub>b</sub> + 
U<sub>b</sub> + V<sub>b</sub> + W<sub>b</sub> + noise</i>

