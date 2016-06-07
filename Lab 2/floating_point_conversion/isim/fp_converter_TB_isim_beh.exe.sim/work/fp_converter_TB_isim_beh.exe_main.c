/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_00000000002790307702_1394248292_init();
    work_m_00000000003239422848_0836205489_init();
    work_m_00000000001279818014_3865691683_init();
    work_m_00000000002502002651_2064777753_init();
    work_m_00000000003853563406_3806343254_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000003853563406_3806343254");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
