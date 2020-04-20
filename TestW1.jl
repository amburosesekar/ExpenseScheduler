using Interact, Mux, WebIO
using InteractBase
#######################
using JuMP
using Juniper
using Ipopt
using Plotly

#ENV["PLOTS_DEFAULT_BACKEND"] = "PlotlyJS"


        function optimization1(Amt1,Days1,xmin1,xmax1,type1)
                optimizer = Juniper.Optimizer
                nl_solver = optimizer_with_attributes(Ipopt.Optimizer, "print_level"=>0)
                #usi5ng LinearAlgebra # for the dot product
                model = Model(optimizer_with_attributes(optimizer, "nl_solver"=>nl_solver))
                #= initialize
                Food,Medicine,Digital,Travel,misc
                =#
                Amount=Amt1#convert(AbstractFloat,10000)
                Days=convert(Int,Days1)
                xmin=xmin1/100#(Float64)[40, 10, 10, 5, 5]/100
                xmax=xmax1/100#(Float64)[60 ,20 ,20, 10, 10]/100

                #xmin=0.2.*rand(5)
                #xmax=xmin .+ (0.99 .-xmin) .*rand(5)



                println(type1)
	            println("hello")
				println(xmin)
                println(xmax)
				println(Amount)


                # Assign Maximum and minimum PerDay Expense
                minXd=(Amount/Days1)*(.90)  # min Assign 90% PerDay
                maxXd=(Amount/Days1)*(1.10)          # max Assign 110% PerDay

				println("hi")
				  println(Days)
                  println(minXd)

                minXdA=minXd.*ones(1,Days)
               println("how")
               println(type1)
                if(type1==1)
                  maxXdA=maxXd.*ones(1,Days)  #Fixed
                else
                  maxXdA=minXdA .+ minXdA .*rand(Days)# rand
                end

                nVar=size(xmin)[1]

                println(nVar)
                W=zeros(nVar,Days)
                Xd=zeros(1,Days)


                # Assign Variable
                W1=repeat(xmin;outer=[1 Days ]) .*1.0
                W2=repeat(xmax;outer=[1 Days ]) .*1.0
                @variable(model, w[i=1:nVar,j=1:Days],lower_bound=W1[i,j],upper_bound=W2[i,j])
                @variable(model, xd[i=1:Days],lower_bound=minXdA[i],upper_bound=maxXdA[i])
                # Assign Minmium and Maximum
                # Assign Constarint
                b=1.0 .*ones(1,Days)

				println(b)
                @constraint(model, con, sum(w,dims=1) .== b)
                b1=Amount
                @constraint(model, con1, sum(xd) .== b1)
                # Run Optimizer
                @objective(model, Min, (sum(w*xd)-Amount))
                #@NLconstraint(m, sum(w[i]*x[i]^2 for i=1:5) <= 45)
                optimize!(model)
                # retrieve the objective value, corresponding x values and the status
                println(JuMP.value.(w))
                println(JuMP.value.(xd))
                println(JuMP.objective_value(model))
                println(JuMP.termination_status(model))
                println((JuMP.value.(w[:,1:4])))

                #y1=Vector{Any}(undef,Days)
                y1 = Array{Float16}(undef, nVar, Days)
                for i=1:Days
                        y1[:,i]=JuMP.value.(w[:,i]) .*JuMP.value.(xd[i])
                end

                # Extract Plot and results

                #ENV["PLOTS_DEFAULT_BACKEND"] = "PlotlyJS"
                ##
                x1 = Vector{String}(undef, Days);
                        for i = 1:Days
                                x1[i]="Day-$i"
                        end
                        println(x1)
                return JuMP,y1,x1;






end




#########################



    d = OrderedDict(:label1 => Widgets.input("Expense Scheduler",style = Dict("font-size"=>"2.8em", "color"=>"#000678","display"=>"flex", "justify-content"=>"center" );type="button"),
        :txt1 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em", "position"=> "static", "margin-left"=> "2.7em","color"=>"#00f678","text-align"=> "center" ),value="21";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Days</div>"))),
        :txt2 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em", "position"=> "static", "margin-left"=> "2.7em","color"=>"#00f678","text-align"=> "center" ),value="10000";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Total Amount</div>"))),
        :label2=> Widgets.input("Cost Min %",style = Dict("font-size"=>"1.5em", "color"=>"#000678","display"=>"flex", "justify-content"=>"center" );type="button"),
        :label3=> Widgets.input("Cost Max %",style = Dict("font-size"=>"1.5em", "color"=>"#000678","display"=>"flex", "justify-content"=>"center" );type="button"),
        :txt3 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "2.7em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="40";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Food</div>")),),
        :txt4 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "2.6em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="60";label=label=HTML(string("<div style='font-size:1.5em;color:#000222'>Food</div>"))),
        :txt5 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> ".7em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="10";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Medicine</div>"))),
        :txt6 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em", "position"=> "static", "margin-left"=> ".7em", "border"=>"3px solid #73AD21","color"=>"#000678","text-align"=> "center" ),value="20";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Medicine</div>"))),
        :txt7 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "1.9em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="10";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Digital</div>"))),
        :txt8 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "1.9em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="20";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Digital</div>"))),
        :txt9 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "2.1em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="5";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Travel</div>"))),
        :txt10 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "2.1em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="10";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Travel</div>"))),
        :txt11 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "2.7em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="5";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Misc</div>"))),
        :txt12 => Widgets.textbox(hint="Enter a Number",style = Dict("font-size"=>"1.5em","width"=>"10em","position"=> "static", "margin-left"=> "2.7em", "border"=>"3px solid #73AD21", "color"=>"#000678","text-align"=> "center" ),value="10";label=HTML(string("<div style='font-size:1.5em;color:#000222'>Misc</div>"))),
        :toggle1 => Widgets.togglebuttons(Dict("Fixed" => 1, "Random" => 2), label=HTML(string("<div style='font-size:1.5em;color:#000222'>PerDay Cost Selection</div>"))),
        :button1    =>Widgets.button("Schedule",style = Dict("position"=> "static", "margin-left"=> "2.7em","width"=>"10em","background-color"=>"#000222")),
		:txtlink => HTML(string("<div style='font-size:1.5em;color:#000222'><a href=\"https://github.com/amburosesekar/ExpenseScheduler\">Julia Code</a></div>")),
        #:lat =>  InteractBase.latex(\\sum_{i=1}^{\\infty} e^i")
        )

    plt = Observable{Any}(Plotly.plot())

    #println(type1)

    ## #



    #plt = Interact.@map plot(sin, color = &output)
    ## #

    t = (Interact.Widget{:mywidget}(d))
    #t = Interact.Widget{:mywidget}(d, output = output)
    #ui=dom"div"(ui,button3,py1)
    Interact.@layout! t vbox(:label1, CSSUtil.vskip(1em),
                           hbox(pad(1em, :txt1), CSSUtil.hskip(2em), :txt2,:txtlink),
                             hbox(CSSUtil.hskip(9em),:label2, CSSUtil.hskip(20em), :label3),
                             hbox(:txt3, CSSUtil.hskip(2em), :txt4),
                             hbox(:txt5, CSSUtil.hskip(2em), :txt6),
                             hbox(:txt7, CSSUtil.hskip(2em), :txt8),
                             hbox(:txt9, CSSUtil.hskip(2em), :txt10),
                             hbox(:txt11, CSSUtil.hskip(2em), :txt12),hbox(:toggle1,CSSUtil.hskip(40em),:button1),CSSUtil.vskip(1em),


    );
    ui = dom"div"(t, plt)
    h = on(d[:button1]) do val
           println("Got an update: ", val)
           days1=parse.(Float64,d[:txt1][])
           amt1=parse.(Float64,d[:txt2][])
           xmin1=parse.(Float64,[d[:txt3][],d[:txt5][],d[:txt7][],d[:txt9][],d[:txt11][]])
           xmax1=parse.(Float64,[d[:txt4][],d[:txt6][],d[:txt8][],d[:txt10][],d[:txt12][]])
           type1=Float64(d[:toggle1][])

           JuMP,y1,x1=optimization1(amt1,days1,xmin1,xmax1,type1)

           trace1 = bar(;x=x1,
                 y=y1[1,:],
           name="Food")
           trace2 = bar(x=x1,
           y=y1[2,:],
          name="Medicine")
          trace3 = bar(x=x1,
                 y=y1[3,:],
           name="Digital")
           trace4 = bar(x=x1,
           y=y1[4,:],
           name="Travel")
                 trace5 = bar(x=x1,
                 y=y1[5,:],
                 name="Misc")
                 data = [trace1, trace2,trace3, trace4,trace5]
                 layout = Layout(;barmode="stack")
                 plt1=Plotly.plot(data, layout)
                 map!(t->plt1,plt,d[:button1])
                 #display(plt)
                 #ui = dom"div"(t, plt)
       end

	using Mux   
    port=80
    try
      WebIO.webio_serve(page("/", req -> ui), port)
    catch e
      if isa(e, IOError)
        # sleep and then try again
        sleep(0.1)
        WebIO.webio_serve(page("/", req -> ui), port)
      else
        throw(e)
      end
    end


    #using Mux
    #WebIO.webio_serve(page("/", req -> ui), 80)
