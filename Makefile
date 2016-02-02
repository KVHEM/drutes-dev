# c=/opt/gcc-trunk/bin/gfortran -fimplicit-none -fbounds-check
# c=gfortran -fimplicit-none  -fcoarray=single -fbounds-check -g3 -fdefault-real-8 -Wextra -Wunused
c=gfortran -fimplicit-none  -fcoarray=single -fbounds-check -fbacktrace -g -g3 -fdefault-real-8 -O0 -finit-real=nan
# c=gfortran-5 -fimplicit-none  -fcoarray=single -fbounds-check -g3 -fdefault-real-8 -O0 -finit-real=nan
# c=gfortran-5 -fimplicit-none  -fcoarray=single -fbounds-check -g3 -fdefault-real-8 -O0 -finit-real=nan
#     c=gfortran -fimplicit-none  -fcoarray=single -fbounds-check -g -fbacktrace
# c=gfortran-5 -fimplicit-none  -fcoarray=single -O3
# c=g95 -g -fbounds-check  -O0 -fimplicit-none  -fintrinsic-extensions -ftr15581 -ftrace=full
#   c=g95  -ftrace=full  -g -fbounds-check  -O3 -funroll-loops -ftr15581 -fimplicit-none
# c=g95   -O3 -ftr15581 -fintrinsic-extensions -fimplicit-none
#     c=g95  -O3 -funroll-loops -fimplicit-none  -ftr15581
#  c=ifort -O3 -fp-model precise -ftz -funroll-loops -coarray -coarray-num-images=1 -implicitnone -debug full
#   c=ifort -O0 -coarray -coarray-num-images=1 -implicitnone -CB -g
#   c=ifort -O0  -implicitnone -CB -g
# c=g95 -std=F -O3 -funroll-loops -ftr15581
# c=/opt/intel/fc/10.1.018/bin/ifort  -O3
#  c=ifort -O3
#c=gfortran -g
d=drutes_obj-`date -I`

all : main.o $(ALL_objs)
	$c -g -o bin/drutes main.o $(ALL_objs)
dir="obj"

servers="miguel@klobouk.fsv.cvut.cz:~  miguel@matsrv-lin01.fsv.cvut.cz:~ miguel@cml.fsv.cvut.cz:~ miguel@193.84.38.21:~"


#----------------objects definitions-------------------------------
CORE_obj := typy.o global_objs.o globals.o globals1D.o globals2D.o  debug_tools.o core_tools.o pde_objs.o
POINTERMAN_obj := manage_pointers.o
RE_obj := re_constitutive.o re_reader.o re_globals.o re_total.o
MATHTOOLS_obj :=  linalg.o integral.o solver_interfaces.o simplelinalg.o
TOOLS_obj := printtools.o simegen.o read_inputs.o drutes_init.o geom_tools.o postpro.o readtools.o
FEMTOOLS_obj := feminittools.o capmat.o stiffmat.o fem.o fem_tools.o femmat.o
DECOMPO_obj :=  decomp_tools.o schwarz_dd.o  decomp_vars.o decomposer.o schwarz_dd2subcyc.o
PMAoo_obj := fullmatrix.o mtx.o mtx_int.o mtxiotools.o pmatools.o solvers.o sparsematrix.o sparsematrix_int.o
modRE_obj := modRE_globals.o modRE_reader.o modRE_constitutive.o modRE_parameter_functions.o modRE_junctions.o
BOUSSINESQ_obj := boussglob.o boussread.o boussfnc.o


ALL_objs := $(CORE_obj) $(TOOLS_obj) $(POINTERMAN_obj) $(MATHTOOLS_obj) $(FEMTOOLS_obj) $(DECOMPO_obj) $(RE_obj) $(PMAoo_obj) $(modRE_obj) $(BOUSSINESQ_obj)
#-----------------------------------------------------------------



#-------begin CORE_obj--------------------------------
typy.o: src/core/typy.f90
	$c -c src/core/typy.f90 
global_objs.o: typy.o $(PMAoo_obj) src/core/global_objs.f90
	$c -c src/core/global_objs.f90
pde_objs.o: typy.o global_objs.o $(PMAoo_obj) globals.o decomp_vars.o src/core/pde_objs.f90
	$c -c src/core/pde_objs.f90
globals.o: typy.o global_objs.o src/core/globals.f90
	$c -c src/core/globals.f90
globals1D.o: typy.o global_objs.o src/core/globals1D.f90
	$c -c src/core/globals1D.f90
globals2D.o: typy.o global_objs.o src/core/globals2D.f90
	$c -c src/core/globals2D.f90
core_tools.o: typy.o global_objs.o globals.o pde_objs.o  src/core/core_tools.f90
	$c -c src/core/core_tools.f90
debug_tools.o: typy.o core_tools.o src/core/debug_tools.f90
	$c -c src/core/debug_tools.f90
#---------end CORE_obj------------------------------


#------begin MATHTOOLS_obj-----------------------------
linalg.o: $(CORE_obj) src/mathtools/linalg.f90
	$c -c src/mathtools/linalg.f90
integral.o: $(CORE_obj) linalg.o src/mathtools/integral.f90
	$c -c src/mathtools/integral.f90
solver_interfaces.o:  $(CORE_obj) $(PMAoo_obj) src/mathtools/solver_interfaces.f90
	$c -c src/mathtools/solver_interfaces.f90
simplelinalg.o:  $(CORE_obj) $(PMAoo_obj) src/mathtools/simplelinalg.f90
	$c -c src/mathtools/simplelinalg.f90
#------end MATHTOOLS_obj---------------------------------


#--------begin PMAoo_obj------------------------
pmatools.o: typy.o src/pma++/pmatools.f90
	$c -c  src/pma++/pmatools.f90
mtx.o: typy.o pmatools.o  src/pma++/mtx.f90
	$c -c src/pma++/mtx.f90
mtx_int.o: typy.o pmatools.o  src/pma++/mtx_int.f90
	$c -c src/pma++/mtx_int.f90	
mtxiotools.o: typy.o src/pma++/mtxiotools.f90
	$c -c src/pma++/mtxiotools.f90 
fullmatrix.o: typy.o mtx.o src/pma++/fullmatrix.f90
	$c -c src/pma++/fullmatrix.f90
sparsematrix.o: typy.o mtx.o src/pma++/sparsematrix.f90
	$c -c src/pma++/sparsematrix.f90
sparsematrix_int.o: typy.o mtx.o src/pma++/sparsematrix_int.f90
	$c -c src/pma++/sparsematrix_int.f90	
solvers.o: typy.o mtx.o src/pma++/solvers.f90
	$c -c src/pma++/solvers.f90
#-------end PMA++_obj---------------------------

#-------begin TOOLS_obj----------------------------------
readtools.o: $(CORE_obj) src/tools/readtools.f90
	$c -c src/tools/readtools.f90
printtools.o: $(CORE_obj) src/tools/printtools.f90
	$c -c src/tools/printtools.f90
geom_tools.o: $(CORE_obj) $(MATHTOOLS_obj) core_tools.o src/tools/geom_tools.f90
	$c -c src/tools/geom_tools.f90
simegen.o:  $(CORE_obj) core_tools.o geom_tools.o src/tools/simegen.f90
	$c -c src/tools/simegen.f90
read_inputs.o:  simegen.o $(CORE_obj) readtools.o src/tools/read_inputs.f90
	$c -c src/tools/read_inputs.f90
drutes_init.o: read_inputs.o readtools.o core_tools.o $(CORE_obj) src/tools/drutes_init.f90
	$c -c src/tools/drutes_init.f90
postpro.o: $(CORE_obj) $(MATHTOOLS_obj) geom_tools.o src/tools/postpro.f90
	$c -c src/tools/postpro.f90
#-------end TOOLS_obj------------------------------------

#-------begin RE_obj--------------------------------
re_globals.o: $(CORE_obj) $(TOOLS_obj) src/models/RE/re_globals.f90
	$c -c  src/models/RE/re_globals.f90
re_constitutive.o: $(CORE_obj) $(TOOLS_obj) re_globals.o src/models/RE/re_constitutive.f90
	$c -c src/models/RE/re_constitutive.f90
re_total.o: $(CORE_obj) $(TOOLS_obj) re_globals.o re_constitutive.o src/models/RE/re_total.f90
	$c -c src/models/RE/re_total.f90	
re_reader.o:  $(CORE_obj) $(TOOLS_obj) re_globals.o src/models/RE/re_reader.f90
	$c -c src/models/RE/re_reader.f90
#-------end CONSTITUTIVE_obj--------------------------------


#-------begin modRE_obj--------------------------------
modRE_globals.o: $(CORE_obj) $(TOOLS_obj) src/models/modRE/modRE_globals.f90
	$c -c src/models/modRE/modRE_globals.f90
modRE_reader.o:  $(CORE_obj) $(TOOLS_obj) $(RE_obj) modRE_globals.o src/models/modRE/modRE_reader.f90
	$c -c src/models/modRE/modRE_reader.f90
modRE_parameter_functions.o : $(CORE_obj) $(TOOLS_obj) modRE_globals.o modRE_reader.o src/models/modRE/modRE_parameter_functions.f90
	$c -c src/models/modRE/modRE_parameter_functions.f90
modRE_constitutive.o : $(CORE_obj) $(TOOLS_obj) modRE_globals.o modRE_reader.o modRE_parameter_functions.o src/models/modRE/modRE_constitutive.f90
	$c -c src/models/modRE/modRE_constitutive.f90
modRE_junctions.o: $(CORE_obj) $(TOOLS_obj) modRE_globals.o modRE_reader.o modRE_parameter_functions.o modRE_constitutive.o src/models/modRE/modRE_junctions.f90
	$c -c src/models/modRE/modRE_junctions.f90
#-------end modRE_obj--------------------------------


#-------begin BOUSSINESQ-----------------------------
boussglob.o:  $(CORE_obj) $(TOOLS_obj) src/models/boussinesq/boussglob.f90
	$c -c src/models/boussinesq/boussglob.f90
boussread.o: $(CORE_obj) $(TOOLS_obj) boussglob.o src/models/boussinesq/boussread.f90
	$c -c src/models/boussinesq/boussread.f90
boussfnc.o:  $(CORE_obj) $(TOOLS_obj) boussglob.o src/models/boussinesq/boussfnc.f90
	$c -c src/models/boussinesq/boussfnc.f90
#-------end BOUSSINESQ-------------------------------



#------begin FEMTOOLS_obj-----------------------------
fem_tools.o:  $(CORE_obj) $(MATHTOOLS_obj) $(TOOLS_obj) $(PMA++_obj) src/femtools/fem_tools.f90
	$c -c  src/femtools/fem_tools.f90
feminittools.o:  $(CORE_obj) $(MATHTOOLS_obj) $(TOOLS_obj) $(RE_obj) $(PMAoo_obj) src/femtools/feminittools.f90
	$c -c src/femtools/feminittools.f90
capmat.o:$(CORE_obj) src/femtools/capmat.f90
	$c -c src/femtools/capmat.f90
stiffmat.o: $(CORE_obj) $(LINALG_obj) fem_tools.o src/femtools/stiffmat.f90
	$c -c src/femtools/stiffmat.f90
femmat.o: $(CORE_obj) $(PMA++_obj) fem_tools.o stiffmat.o capmat.o decomp_vars.o src/femtools/femmat.f90
	$c -c src/femtools/femmat.f90
fem.o: $(CORE_obj) $(LINALG_obj) $(DECOMPO_obj)  femmat.o  src/femtools/fem.f90
	$c -c src/femtools/fem.f90
#------end FEMTOOLS_obj------------------------------



#-------begin POINTERS_obj--------------------------------
manage_pointers.o: $(CORE_obj) $(TOOLS_obj) $(CORE_obj) $(FEMTOOLS_obj) $(LINALG_obj) $(RE_obj) $(DECOMPO_obj) $(modRE_obj) $(BOUSSINESQ_obj) src/pointerman/manage_pointers.f90
	$c -c src/pointerman/manage_pointers.f90
#-------end pointers_obj--------------------------------


#-------begin DECOMPO_obj--------------------------------
decomp_vars.o:  $(PMAoo_obj) src/decompo/decomp_vars.f90
	$c -c src/decompo/decomp_vars.f90
decomposer.o: $(CORE_obj) $(TOOLS_obj) $(PMAoo_obj) decomp_vars.o decomp_tools.o src/decompo/decomposer.f90
	$c -c src/decompo/decomposer.f90
decomp_tools.o: $(CORE_obj) $(MATHTOOLS_obj) decomp_vars.o  src/decompo/decomp_tools.f90
	$c -c src/decompo/decomp_tools.f90
schwarz_dd.o:  $(CORE_obj) $(MATHTOOLS_obj)  femmat.o decomp_vars.o decomposer.o decomp_tools.o src/decompo/schwarz_dd.f90
	$c -c src/decompo/schwarz_dd.f90
schwarz_dd2subcyc.o: $(CORE_obj) $(MATHTOOLS_obj)  femmat.o decomp_vars.o decomposer.o decomp_tools.o src/decompo/schwarz_dd2subcyc.f90
	$c -c src/decompo/schwarz_dd2subcyc.f90
#-------end DECOMPO_obj--------------------------------


#----build main---------
main.o:  $(ALL_objs) src/core/main.f90
	$c -c src/core/main.f90
#-----------------------


clean:
	rm -rf *.o *.mod bin/*

syncup:
	cat /etc/hostname > sync.stamp && date >> sync.stamp && rsync -avztu -e ssh --delete --exclude 'out' --exclude '*.o' --exclude '*.mod' --exclude 'bin'  --exclude '*~' --exclude '*attr' ./ miguel@cml.fsv.cvut.cz:~/drutes-obj/

syncdown:
	rsync -avztu -e ssh --delete --exclude 'out/*' miguel@cml.fsv.cvut.cz:~/drutes-obj/ ./ && echo "last sync:" && cat sync.stamp
		
	
alesup: 
	date > jsync.stamp &&  rsync -avztu -e ssh --delete --exclude 'out' --exclude '*.o' --exclude '*.mod' --exclude 'bin'  --exclude '*~' ./ jakub@matsrv-lin01.fsv.cvut.cz:~/drutes/

alesdown: 
	rsync -avztu -e ssh --delete --exclude 'out/*' jakub@matsrv-lin01.fsv.cvut.cz:~/drutes/ ./


petrup:
	rsync -avztu -e ssh --delete --exclude 'out' --exclude '*.o' --exclude '*.mod' --exclude 'bin'  --exclude '*~' ./ pmayer@matsrv-lin01.fsv.cvut.cz:~/drutes/
	
petrdown:
	rsync -avztu -e ssh --delete --exclude 'out/*' pmayer@matsrv-lin01.fsv.cvut.cz:~/drutes/ ./


save:
	 tar -czf $d.tgz src Makefile drutes.conf  ; for i in `echo $(servers)` ; do scp -P 22  $d.tgz $$i; done

tar :
	 tar -czf $d.tgz src Makefile drutes.conf 

upcurrent:
	rsync -avztu -e ssh --delete --exclude 'out/*' --exclude '*.o' --exclude '*.mod' --exclude 'bin/*'  --exclude '*~' ./ miguel@matsrv-lin01.fsv.cvut.cz:~/drutes-archive/

current:
	rsync -avztu --delete --exclude 'out/*' rsync://drutes@matsrv-lin01.fsv.cvut.cz/drutes/ ./