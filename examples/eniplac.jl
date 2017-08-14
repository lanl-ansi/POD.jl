using POD, JuMP, CPLEX, Ipopt, MathProgBase, AmplNLWriter, CoinOptServices

function eniplac(;verbose=false, solver=nothing, convhull=true, exprmode=1, sos2=true, presolve=0)

    if solver == nothing
        m = Model(solver=PODSolver(nlp_local_solver=BonminNLSolver(["bonmin.iteration_limit=100"; "bonmin.nlp_log_level=0"; "bonmin.bb_log_level=0"]),
                                    mip_solver=CplexSolver(CPX_PARAM_SCRIND=1),
                                    presolve_bound_tightening=(presolve>0),
                                    presolve_bound_tightening_algo=presolve,
                                    bilinear_convexhull=false,
                                    monomial_convexhull=convhull,
									convexhull_use_sos2=sos2,
                                    discretization_ratio=8,
                                    # discretization_var_pick_algo="min_vertex_cover",
                                    log_level=1,
                                    rel_gap=0.0001))
    else
        m = Model(solver=solver)
    end

    # ----- Variables ----- #
    @variable(m, objvar)
    xIdx = Any[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117]
    @variable(m, x[xIdx])
    bIdx = Any[119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142]
    @variable(m, b[bIdx])
    setlowerbound(x[117], 0.0)
    setlowerbound(x[85], 0.0)
    setlowerbound(x[101], 0.0)
    setlowerbound(x[16], 0.0)
    setlowerbound(x[89], 0.0)
    setlowerbound(x[93], 0.0)
    setlowerbound(x[14], 0.0)
    setlowerbound(x[62], 0.0)
    setlowerbound(x[114], 0.0)
    setcategory(b[120], :Bin)
    setcategory(b[128], :Bin)
    setlowerbound(x[78], 0.0)
    setlowerbound(x[91], 0.0)
    setlowerbound(x[56], 0.0)
    setlowerbound(x[105], 0.0)
    setlowerbound(x[22], 0.0)
    setlowerbound(x[59], 0.0)
    setlowerbound(x[77], 0.0)
    setlowerbound(x[110], 0.0)
    setcategory(b[133], :Bin)
    setcategory(b[137], :Bin)
    setlowerbound(x[74], 0.0)
    setlowerbound(x[2], 0.0)
    setcategory(b[124], :Bin)
    setcategory(b[141], :Bin)
    setlowerbound(x[9], 0.0)
    setlowerbound(x[92], 0.0)
    setlowerbound(x[8], 0.0)
    setlowerbound(x[100], 0.0)
    setlowerbound(x[69], 0.0)
    setlowerbound(x[106], 0.0)
    setlowerbound(x[81], 0.0)
    setlowerbound(x[111], 0.0)
    setcategory(b[136], :Bin)
    setlowerbound(x[71], 0.0)
    setcategory(b[130], :Bin)
    setlowerbound(x[4], 0.0)
    setlowerbound(x[54], 0.0)
    setlowerbound(x[96], 0.0)
    setlowerbound(x[87], 0.0)
    setcategory(b[132], :Bin)
    setlowerbound(x[3], 0.0)
    setlowerbound(x[58], 0.0)
    setcategory(b[127], :Bin)
    setlowerbound(x[88], 0.0)
    setlowerbound(x[11], 0.0)
    setlowerbound(x[94], 0.0)
    setlowerbound(x[53], 0.0)
    setcategory(b[119], :Bin)
    setlowerbound(x[5], 0.0)
    setlowerbound(x[63], 0.0)
    setlowerbound(x[57], 0.0)
    setlowerbound(x[55], 0.0)
    setlowerbound(x[82], 0.0)
    setlowerbound(x[24], 0.0)
    setcategory(b[126], :Bin)
    setlowerbound(x[18], 0.0)
    setlowerbound(x[52], 0.0)
    setlowerbound(x[104], 0.0)
    setlowerbound(x[1], 0.0)
    setlowerbound(x[7], 0.0)
    setlowerbound(x[13], 0.0)
    setlowerbound(x[49], 0.0)
    setcategory(b[129], :Bin)
    setlowerbound(x[21], 0.0)
    setlowerbound(x[10], 0.0)
    setlowerbound(x[72], 0.0)
    setlowerbound(x[80], 0.0)
    setlowerbound(x[67], 0.0)
    setlowerbound(x[86], 0.0)
    setlowerbound(x[79], 0.0)
    setlowerbound(x[103], 0.0)
    setlowerbound(x[107], 0.0)
    setcategory(b[125], :Bin)
    setcategory(b[142], :Bin)
    setlowerbound(x[66], 0.0)
    setlowerbound(x[75], 0.0)
    setlowerbound(x[12], 0.0)
    setlowerbound(x[116], 0.0)
    setcategory(b[138], :Bin)
    setlowerbound(x[95], 0.0)
    setcategory(b[135], :Bin)
    setlowerbound(x[61], 0.0)
    setlowerbound(x[50], 0.0)
    setlowerbound(x[90], 0.0)
    setlowerbound(x[68], 0.0)
    setlowerbound(x[99], 0.0)
    setlowerbound(x[64], 0.0)
    setlowerbound(x[112], 0.0)
    setlowerbound(x[115], 0.0)
    setcategory(b[134], :Bin)
    setlowerbound(x[6], 0.0)
    setlowerbound(x[60], 0.0)
    setlowerbound(x[17], 0.0)
    setlowerbound(x[23], 0.0)
    setlowerbound(x[84], 0.0)
    setcategory(b[140], :Bin)
    setlowerbound(x[51], 0.0)
    setlowerbound(x[109], 0.0)
    setcategory(b[123], :Bin)
    setlowerbound(x[19], 0.0)
    setlowerbound(x[73], 0.0)
    setcategory(b[122], :Bin)
    setlowerbound(x[20], 0.0)
    setcategory(b[121], :Bin)
    setcategory(b[139], :Bin)
    setlowerbound(x[15], 0.0)
    setlowerbound(x[108], 0.0)
    setlowerbound(x[70], 0.0)
    setlowerbound(x[83], 0.0)
    setlowerbound(x[102], 0.0)
    setcategory(b[131], :Bin)
    setlowerbound(x[65], 0.0)
    setlowerbound(x[76], 0.0)
    setupperbound(x[99],500.0)
    setupperbound(x[100],100.0)
    setupperbound(x[101],100.0)
    setupperbound(x[102],100.0)
    setupperbound(x[103],100.0)
    setupperbound(x[104],100.0)
    setupperbound(x[105],500.0)
    setupperbound(x[106],500.0)
    setupperbound(x[107],500.0)
    setupperbound(x[108],500.0)
    setupperbound(x[109],500.0)
    setupperbound(x[110],500.0)


    # ----- Constraints ----- #
    @constraint(m, e1,-3.3*x[73]-3.2*x[74]-3.1*x[75]-3.25*x[76]-3.3*x[77]-3.2*x[78]-3.1*x[79]-3.25*x[80]-3.3*x[81]-3.2*x[82]-3.1*x[83]-3.25*x[84]-3.3*x[85]-3.2*x[86]-3.1*x[87]-3.25*x[88]-3.3*x[89]-3.2*x[90]-3.1*x[91]-3.25*x[92]-3.3*x[93]-3.2*x[94]-3.1*x[95]-3.25*x[96]+x[113]==0.0)
    @constraint(m, e2,-33*x[105]-33*x[106]-33*x[107]-33*x[108]-33*x[109]-33*x[110]+x[112]==0.0)
    @constraint(m, e3,x[25]-b[119]==0.0)
    @constraint(m, e4,x[26]-b[120]==0.0)
    @constraint(m, e5,x[27]-b[121]==0.0)
    @constraint(m, e6,x[28]-b[122]==0.0)
    @constraint(m, e7,x[29]-b[123]==0.0)
    @constraint(m, e8,x[30]-b[124]==0.0)
    @constraint(m, e9,x[31]-b[125]==0.0)
    @constraint(m, e10,x[32]-b[126]==0.0)
    @constraint(m, e11,x[33]-b[127]==0.0)
    @constraint(m, e12,x[34]-b[128]==0.0)
    @constraint(m, e13,x[35]-b[129]==0.0)
    @constraint(m, e14,x[36]-b[130]==0.0)
    @constraint(m, e15,x[37]-b[131]==0.0)
    @constraint(m, e16,x[38]-b[132]==0.0)
    @constraint(m, e17,x[39]-b[133]==0.0)
    @constraint(m, e18,x[40]-b[134]==0.0)
    @constraint(m, e19,x[41]-b[135]==0.0)
    @constraint(m, e20,x[42]-b[136]==0.0)
    @constraint(m, e21,x[43]-b[137]==0.0)
    @constraint(m, e22,x[44]-b[138]==0.0)
    @constraint(m, e23,x[45]-b[139]==0.0)
    @constraint(m, e24,x[46]-b[140]==0.0)
    @constraint(m, e25,x[47]-b[141]==0.0)
    @constraint(m, e26,x[48]-b[142]==0.0)
    @constraint(m, e27,x[1]+x[2]+x[3]+x[4]-x[99]+x[105]==1170.0)
    @constraint(m, e28,x[5]+x[6]+x[7]+x[8]-x[100]+x[106]==950.0)
    @constraint(m, e29,x[9]+x[10]+x[11]+x[12]-x[101]+x[107]==950.0)
    @constraint(m, e30,x[13]+x[14]+x[15]+x[16]-x[102]+x[108]==700.0)
    @constraint(m, e31,x[17]+x[18]+x[19]+x[20]-x[103]+x[109]==600.0)
    @constraint(m, e32,x[21]+x[22]+x[23]+x[24]-x[104]+x[110]==250.0)

    # @NLconstraint(m, e33,-(601.56+0.0131*(x[1])^2+1.0622*x[1])*x[25]+x[73]==0.0)
    # @NLconstraint(m, e34,-(10.04286*x[2]-0.01048* (x[2])^2-92.8095)*x[26]+x[74]==0.0)
    # @NLconstraint(m, e35,-(657.32+0.018317* (x[3])^2)*x[27]+x[75]==0.0)
    # @NLconstraint(m, e36,-(222.2+0.0001* (x[4])^2+6.2749*x[4])*x[28]+x[76]==0.0)
    # @NLconstraint(m, e37,-(601.56+0.0131* (x[5])^2+1.0622*x[5])*x[29]+x[77]==0.0)
    # @NLconstraint(m, e38,-(10.04286*x[6]-0.01048* (x[6])^2-92.8095)*x[30]+x[78]==0.0)
    # @NLconstraint(m, e39,-(657.32+0.018317* (x[7])^2)*x[31]+x[79]==0.0)
    # @NLconstraint(m, e40,-(222.2+0.0001* (x[8])^2+6.2749*x[8])*x[32]+x[80]==0.0)
    # @NLconstraint(m, e41,-(601.56+0.0131* (x[9])^2+1.0622*x[9])*x[33]+x[81]==0.0)
    # @NLconstraint(m, e42,-(10.04286*x[10]-0.01048* (x[10])^2-92.8095)*x[34]+x[82]==0.0)
    # @NLconstraint(m, e43,-(657.32+0.018317* (x[11])^2)*x[35]+x[83]==0.0)
    # @NLconstraint(m, e44,-(222.2+0.0001* (x[12])^2+6.2749*x[12])*x[36]+x[84]==0.0)
    # @NLconstraint(m, e45,-(601.56+0.0131* (x[13])^2+1.0622*x[13])*x[37]+x[85]==0.0)
    # @NLconstraint(m, e46,-(10.04286*x[14]-0.01048* (x[14])^2-92.8095)*x[38]+x[86]==0.0)
    # @NLconstraint(m, e47,-(657.32+0.018317* (x[15])^2)*x[39]+x[87]==0.0)
    # @NLconstraint(m, e48,-(222.2+0.0001* (x[16])^2+6.2749*x[16])*x[40]+x[88]==0.0)
    # @NLconstraint(m, e49,-(601.56+0.0131* (x[17])^2+1.0622*x[17])*x[41]+x[89]==0.0)
    # @NLconstraint(m, e50,-(10.04286*x[18]-0.01048* (x[18])^2-92.8095)*x[42]+x[90]==0.0)
    # @NLconstraint(m, e51,-(657.32+0.018317* (x[19])^2)*x[43]+x[91]==0.0)
    # @NLconstraint(m, e52,-(222.2+0.0001* (x[20])^2+6.2749*x[20])*x[44]+x[92]==0.0)
    # @NLconstraint(m, e53,-(601.56+0.0131* (x[21])^2+1.0622*x[21])*x[45]+x[93]==0.0)
    # @NLconstraint(m, e54,-(10.04286*x[22]-0.01048* (x[22])^2-92.8095)*x[46]+x[94]==0.0)
    # @NLconstraint(m, e55,-(657.32+0.018317* (x[23])^2)*x[47]+x[95]==0.0)
    # @NLconstraint(m, e56,-(222.2+0.0001* (x[24])^2+6.2749*x[24])*x[48]+x[96]==0.0)

    # Expanded formulation
    if exprmode == 1
        @NLconstraint(m, e33,-(601.56*x[25]+0.0131*(x[1])^2*x[25]+1.0622*x[1]*x[25])+x[73]==0.0)
        @NLconstraint(m, e34,-(10.04286*x[2]*x[26]-0.01048*(x[2])^2*x[26]-92.8095*x[26])+x[74]==0.0)
        @NLconstraint(m, e35,-(657.32*x[27]+0.018317*(x[3])^2*x[27])+x[75]==0.0)
        @NLconstraint(m, e36,-(222.2*x[28]+0.0001*(x[4])^2*x[28]+6.2749*x[4]*x[28])+x[76]==0.0)
        @NLconstraint(m, e37,-(601.56*x[29]+0.0131*(x[5])^2*x[29]+1.0622*x[5]*x[29])+x[77]==0.0)
        @NLconstraint(m, e38,-(10.04286*x[6]*x[30]-0.01048*(x[6])^2*x[30]-92.8095*x[30])+x[78]==0.0)
        @NLconstraint(m, e39,-(657.32*x[31]+0.018317*(x[7])^2*x[31])+x[79]==0.0)
        @NLconstraint(m, e40,-(222.2*x[32]+0.0001*(x[8])^2*x[32]+6.2749*x[8]*x[32])+x[80]==0.0)
        @NLconstraint(m, e41,-(601.56*x[33]+0.0131*(x[9])^2*x[33]+1.0622*x[9]*x[33])+x[81]==0.0)
        @NLconstraint(m, e42,-(10.04286*x[10]*x[34]-0.01048*(x[10])^2*x[34]-92.8095*x[34])+x[82]==0.0)
        @NLconstraint(m, e43,-(657.32*x[35]+0.018317*(x[11])^2*x[35])+x[83]==0.0)
        @NLconstraint(m, e44,-(222.2*x[36]+0.0001*(x[12])^2*x[36]+6.2749*x[12]*x[36])+x[84]==0.0)
        @NLconstraint(m, e45,-(601.56*x[37]+0.0131*(x[13])^2*x[37]+1.0622*x[13]*x[37])+x[85]==0.0)
        @NLconstraint(m, e46,-(10.04286*x[14]*x[38]-0.01048*(x[14])^2*x[38]-92.8095*x[38])+x[86]==0.0)
        @NLconstraint(m, e47,-(657.32*x[39]+0.018317*(x[15])^2*x[39])+x[87]==0.0)
        @NLconstraint(m, e48,-(222.2*x[40]+0.0001*(x[16])^2*x[40]+6.2749*x[16]*x[40])+x[88]==0.0)
        @NLconstraint(m, e49,-(601.56*x[41]+0.0131*(x[17])^2*x[41]+1.0622*x[17]*x[41])+x[89]==0.0)
        @NLconstraint(m, e50,-(10.04286*x[18]*x[42]-0.01048*(x[18])^2*x[42]-92.8095*x[42])+x[90]==0.0)
        @NLconstraint(m, e51,-(657.32*x[43]+0.018317*(x[19])^2*x[43])+x[91]==0.0)
        @NLconstraint(m, e52,-(222.2*x[44]+0.0001*(x[20])^2*x[44]+6.2749*x[20]*x[44])+x[92]==0.0)
        @NLconstraint(m, e53,-(601.56*x[45]+0.0131*(x[21])^2*x[45]+1.0622*x[21]*x[45])+x[93]==0.0)
        @NLconstraint(m, e54,-(10.04286*x[22]*x[46]-0.01048*(x[22])^2*x[46]-92.8095*x[46])+x[94]==0.0)
        @NLconstraint(m, e55,-(657.32*x[47]+0.018317*(x[23])^2*x[47])+x[95]==0.0)
        @NLconstraint(m, e56,-(222.2*x[48]+0.0001*(x[24])^2*x[48]+6.2749*x[24]*x[48])+x[96]==0.0)
    elseif exprmode == 2
        # (Benchmark) Experimental formulation
        @NLconstraint(m, e33,-(601.56*x[25]+0.0131*x[1]*x[1]*x[25]+1.0622*x[1]*x[25])+x[73]==0.0)
        @NLconstraint(m, e34,-(10.04286*x[2]*x[26]-0.01048*x[2]*x[2]*x[26]-92.8095*x[26])+x[74]==0.0)
        @NLconstraint(m, e35,-(657.32*x[27]+0.018317*x[3]*x[3]*x[27])+x[75]==0.0)
        @NLconstraint(m, e36,-(222.2*x[28]+0.0001*x[4]*x[4]*x[28]+6.2749*x[4]*x[28])+x[76]==0.0)
        @NLconstraint(m, e37,-(601.56*x[29]+0.0131*x[5]*x[5]*x[29]+1.0622*x[5]*x[29])+x[77]==0.0)
        @NLconstraint(m, e38,-(10.04286*x[6]*x[30]-0.01048*x[6]*x[6]*x[30]-92.8095*x[30])+x[78]==0.0)
        @NLconstraint(m, e39,-(657.32*x[31]+0.018317*x[7]*x[7]*x[31])+x[79]==0.0)
        @NLconstraint(m, e40,-(222.2*x[32]+0.0001*x[8]*x[8]*x[32]+6.2749*x[8]*x[32])+x[80]==0.0)
        @NLconstraint(m, e41,-(601.56*x[33]+0.0131*x[9]*x[9]*x[33]+1.0622*x[9]*x[33])+x[81]==0.0)
        @NLconstraint(m, e42,-(10.04286*x[10]*x[34]-0.01048*x[10]*x[10]*x[34]-92.8095*x[34])+x[82]==0.0)
        @NLconstraint(m, e43,-(657.32*x[35]+0.018317*x[11]*x[11]*x[35])+x[83]==0.0)
        @NLconstraint(m, e44,-(222.2*x[36]+0.0001*x[12]*x[12]*x[36]+6.2749*x[12]*x[36])+x[84]==0.0)
        @NLconstraint(m, e45,-(601.56*x[37]+0.0131*x[13]*x[13]*x[37]+1.0622*x[13]*x[37])+x[85]==0.0)
        @NLconstraint(m, e46,-(10.04286*x[14]*x[38]-0.01048*x[14]*x[14]*x[38]-92.8095*x[38])+x[86]==0.0)
        @NLconstraint(m, e47,-(657.32*x[39]+0.018317*x[15]*x[15]*x[39])+x[87]==0.0)
        @NLconstraint(m, e48,-(222.2*x[40]+0.0001*x[16]*x[16]*x[40]+6.2749*x[16]*x[40])+x[88]==0.0)
        @NLconstraint(m, e49,-(601.56*x[41]+0.0131*x[17]*x[17]*x[41]+1.0622*x[17]*x[41])+x[89]==0.0)
        @NLconstraint(m, e50,-(10.04286*x[18]*x[42]-0.01048*x[18]*x[18]*x[42]-92.8095*x[42])+x[90]==0.0)
        @NLconstraint(m, e51,-(657.32*x[43]+0.018317*x[19]*x[19]*x[43])+x[91]==0.0)
        @NLconstraint(m, e52,-(222.2*x[44]+0.0001*x[20]*x[20]*x[44]+6.2749*x[20]*x[44])+x[92]==0.0)
        @NLconstraint(m, e53,-(601.56*x[45]+0.0131*x[21]*x[21]*x[45]+1.0622*x[21]*x[45])+x[93]==0.0)
        @NLconstraint(m, e54,-(10.04286*x[22]*x[46]-0.01048*x[22]*x[22]*x[46]-92.8095*x[46])+x[94]==0.0)
        @NLconstraint(m, e55,-(657.32*x[47]+0.018317*x[23]*x[23]*x[47])+x[95]==0.0)
        @NLconstraint(m, e56,-(222.2*x[48]+0.0001*x[24]*x[24]*x[48]+6.2749*x[24]*x[48])+x[96]==0.0)
    else
        error("Only support expression mode 1-2..")
    end

    @constraint(m, e57,-x[73]-x[77]-x[81]-x[85]-x[89]-x[93]+x[114]==0.0)
    @constraint(m, e58,-x[74]-x[78]-x[82]-x[86]-x[90]-x[94]+x[115]==0.0)
    @constraint(m, e59,-x[75]-x[79]-x[83]-x[87]-x[91]-x[95]+x[116]==0.0)
    @constraint(m, e60,-x[76]-x[80]-x[84]-x[88]-x[92]-x[96]+x[117]==0.0)
    @constraint(m, e61,x[98]==231000.0)
    @constraint(m, e62,-30*x[99]-30*x[100]-30*x[101]-30*x[102]-30*x[103]-30*x[104]+x[111]==0.0)
    @constraint(m, e63,x[97]-x[98]-x[111]==0.0)
    @constraint(m, e64,-x[1]+x[5]<=500.0)
    @constraint(m, e65,-x[2]+x[6]<=500.0)
    @constraint(m, e66,-x[3]+x[7]<=500.0)
    @constraint(m, e67,-x[4]+x[8]<=500.0)
    @constraint(m, e68,-x[5]+x[9]<=500.0)
    @constraint(m, e69,-x[6]+x[10]<=500.0)
    @constraint(m, e70,-x[7]+x[11]<=500.0)
    @constraint(m, e71,-x[8]+x[12]<=500.0)
    @constraint(m, e72,-x[9]+x[13]<=500.0)
    @constraint(m, e73,-x[10]+x[14]<=500.0)
    @constraint(m, e74,-x[11]+x[15]<=500.0)
    @constraint(m, e75,-x[12]+x[16]<=500.0)
    @constraint(m, e76,-x[13]+x[17]<=500.0)
    @constraint(m, e77,-x[14]+x[18]<=500.0)
    @constraint(m, e78,-x[15]+x[19]<=500.0)
    @constraint(m, e79,-x[16]+x[20]<=500.0)
    @constraint(m, e80,-x[17]+x[21]<=500.0)
    @constraint(m, e81,-x[18]+x[22]<=500.0)
    @constraint(m, e82,-x[19]+x[23]<=500.0)
    @constraint(m, e83,-x[20]+x[24]<=500.0)
    @constraint(m, e84,x[1]-x[5]<=500.0)
    @constraint(m, e85,x[2]-x[6]<=500.0)
    @constraint(m, e86,x[3]-x[7]<=500.0)
    @constraint(m, e87,x[4]-x[8]<=500.0)
    @constraint(m, e88,x[5]-x[9]<=500.0)
    @constraint(m, e89,x[6]-x[10]<=500.0)
    @constraint(m, e90,x[7]-x[11]<=500.0)
    @constraint(m, e91,x[8]-x[12]<=500.0)
    @constraint(m, e92,x[9]-x[13]<=500.0)
    @constraint(m, e93,x[10]-x[14]<=500.0)
    @constraint(m, e94,x[11]-x[15]<=500.0)
    @constraint(m, e95,x[12]-x[16]<=500.0)
    @constraint(m, e96,x[13]-x[17]<=500.0)
    @constraint(m, e97,x[14]-x[18]<=500.0)
    @constraint(m, e98,x[15]-x[19]<=500.0)
    @constraint(m, e99,x[16]-x[20]<=500.0)
    @constraint(m, e100,x[17]-x[21]<=500.0)
    @constraint(m, e101,x[18]-x[22]<=500.0)
    @constraint(m, e102,x[19]-x[23]<=500.0)
    @constraint(m, e103,x[20]-x[24]<=500.0)
    @constraint(m, e104,x[1]<=800.0)
    @constraint(m, e105,x[2]<=650.0)
    @constraint(m, e106,x[3]<=660.0)
    @constraint(m, e107,x[4]<=750.0)
    @constraint(m, e108,-x[1]<=200.0)
    @constraint(m, e109,-x[2]<=350.0)
    @constraint(m, e110,-x[3]<=340.0)
    @constraint(m, e111,-x[4]<=250.0)
    @constraint(m, e112,x[1]+x[49]-250*b[119]==0.0)
    @constraint(m, e113,x[2]+x[50]-170*b[120]==0.0)
    @constraint(m, e114,x[3]+x[51]-260*b[121]==0.0)
    @constraint(m, e115,x[4]+x[52]-510*b[122]==0.0)
    @constraint(m, e116,x[5]+x[53]-250*b[123]==0.0)
    @constraint(m, e117,x[6]+x[54]-170*b[124]==0.0)
    @constraint(m, e118,x[7]+x[55]-260*b[125]==0.0)
    @constraint(m, e119,x[8]+x[56]-510*b[126]==0.0)
    @constraint(m, e120,x[9]+x[57]-250*b[127]==0.0)
    @constraint(m, e121,x[10]+x[58]-170*b[128]==0.0)
    @constraint(m, e122,x[11]+x[59]-260*b[129]==0.0)
    @constraint(m, e123,x[12]+x[60]-510*b[130]==0.0)
    @constraint(m, e124,x[13]+x[61]-250*b[131]==0.0)
    @constraint(m, e125,x[14]+x[62]-170*b[132]==0.0)
    @constraint(m, e126,x[15]+x[63]-260*b[133]==0.0)
    @constraint(m, e127,x[16]+x[64]-510*b[134]==0.0)
    @constraint(m, e128,x[17]+x[65]-250*b[135]==0.0)
    @constraint(m, e129,x[18]+x[66]-170*b[136]==0.0)
    @constraint(m, e130,x[19]+x[67]-260*b[137]==0.0)
    @constraint(m, e131,x[20]+x[68]-510*b[138]==0.0)
    @constraint(m, e132,x[21]+x[69]-250*b[139]==0.0)
    @constraint(m, e133,x[22]+x[70]-170*b[140]==0.0)
    @constraint(m, e134,x[23]+x[71]-260*b[141]==0.0)
    @constraint(m, e135,x[24]+x[72]-510*b[142]==0.0)
    @constraint(m, e136,x[49]+x[50]+x[51]+x[52]>=25.0)
    @constraint(m, e137,x[53]+x[54]+x[55]+x[56]>=25.0)
    @constraint(m, e138,x[57]+x[58]+x[59]+x[60]>=25.0)
    @constraint(m, e139,x[61]+x[62]+x[63]+x[64]>=25.0)
    @constraint(m, e140,x[65]+x[66]+x[67]+x[68]>=25.0)
    @constraint(m, e141,x[69]+x[70]+x[71]+x[72]>=25.0)
    @constraint(m, e142,x[1]-250*b[119]<=0.0)
    @constraint(m, e143,x[2]-170*b[120]<=0.0)
    @constraint(m, e144,x[3]-260*b[121]<=0.0)
    @constraint(m, e145,x[4]-510*b[122]<=0.0)
    @constraint(m, e146,x[5]-250*b[123]<=0.0)
    @constraint(m, e147,x[6]-170*b[124]<=0.0)
    @constraint(m, e148,x[7]-260*b[125]<=0.0)
    @constraint(m, e149,x[8]-510*b[126]<=0.0)
    @constraint(m, e150,x[9]-250*b[127]<=0.0)
    @constraint(m, e151,x[10]-170*b[128]<=0.0)
    @constraint(m, e152,x[11]-260*b[129]<=0.0)
    @constraint(m, e153,x[12]-510*b[130]<=0.0)
    @constraint(m, e154,x[13]-250*b[131]<=0.0)
    @constraint(m, e155,x[14]-170*b[132]<=0.0)
    @constraint(m, e156,x[15]-260*b[133]<=0.0)
    @constraint(m, e157,x[16]-510*b[134]<=0.0)
    @constraint(m, e158,x[17]-250*b[135]<=0.0)
    @constraint(m, e159,x[18]-170*b[136]<=0.0)
    @constraint(m, e160,x[19]-260*b[137]<=0.0)
    @constraint(m, e161,x[20]-510*b[138]<=0.0)
    @constraint(m, e162,x[21]-250*b[139]<=0.0)
    @constraint(m, e163,x[22]-170*b[140]<=0.0)
    @constraint(m, e164,x[23]-260*b[141]<=0.0)
    @constraint(m, e165,x[24]-510*b[142]<=0.0)
    @constraint(m, e166,x[1]-140*b[119]>=0.0)
    @constraint(m, e167,x[2]-140*b[120]>=0.0)
    @constraint(m, e168,x[3]-140*b[121]>=0.0)
    @constraint(m, e169,x[4]-160*b[122]>=0.0)
    @constraint(m, e170,x[5]-140*b[123]>=0.0)
    @constraint(m, e171,x[6]-140*b[124]>=0.0)
    @constraint(m, e172,x[7]-140*b[125]>=0.0)
    @constraint(m, e173,x[8]-160*b[126]>=0.0)
    @constraint(m, e174,x[9]-140*b[127]>=0.0)
    @constraint(m, e175,x[10]-140*b[128]>=0.0)
    @constraint(m, e176,x[11]-140*b[129]>=0.0)
    @constraint(m, e177,x[12]-160*b[130]>=0.0)
    @constraint(m, e178,x[13]-140*b[131]>=0.0)
    @constraint(m, e179,x[14]-140*b[132]>=0.0)
    @constraint(m, e180,x[15]-140*b[133]>=0.0)
    @constraint(m, e181,x[16]-160*b[134]>=0.0)
    @constraint(m, e182,x[17]-140*b[135]>=0.0)
    @constraint(m, e183,x[18]-140*b[136]>=0.0)
    @constraint(m, e184,x[19]-140*b[137]>=0.0)
    @constraint(m, e185,x[20]-160*b[138]>=0.0)
    @constraint(m, e186,x[21]-140*b[139]>=0.0)
    @constraint(m, e187,x[22]-140*b[140]>=0.0)
    @constraint(m, e188,x[23]-140*b[141]>=0.0)
    @constraint(m, e189,x[24]-160*b[142]>=0.0)
    @constraint(m, e190,-x[97]+x[112]+x[113]-objvar==0.0)

    # ----- Objective ----- #
    @objective(m, Min, objvar)

    if verbose
        print(m)
    end

    return m
end
