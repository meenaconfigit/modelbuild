using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Configit.Model;
using System.Diagnostics;
namespace PMXC
{
    class Program
    {
        private static Workspace ws;
        static int Main(string[] args)
        {
            if (args.Length != 1)
            {
                return -1;
            }
            string pmxfile = args[0];
            string pmxname = pmxfile.Split('.')[0];
            string modelfileName = pmxname + ".model";            
            ws = new Workspace(modelfileName, Workspace.OpenMode.ForceNew);       
        
            ws.ImportFromXml(pmxfile);
            ProcessStartInfo process_start_info = new ProcessStartInfo();
            process_start_info.FileName = @"C:\Program Files (x86)\Configit Model 5.9\Bin\db2pm.exe";
            process_start_info.Arguments = "-pm " + pmxname + " -compile " + modelfileName;
            var process = Process.Start(process_start_info);
            process.WaitForExit();
            var exitCode = process.ExitCode;
            process.Close();
            ws.Dispose();
            File.Delete(modelfileName);
            return 0;
        }
    }
}
