package net.sourceforge.pldoc.mojo;

/*
 * Copyright 2001-2005 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import java.util.Locale;
import org.apache.maven.plugin.MojoExecutionException;

import java.io.File;
import java.util.ResourceBundle;
import net.sourceforge.pldoc.Settings;
import net.sourceforge.pldoc.ant.PLDocTask;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.project.MavenProject;
import org.apache.maven.reporting.MavenReport;
import org.apache.maven.reporting.MavenReportException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.FileSet;
import org.codehaus.doxia.sink.Sink;
import org.codehaus.plexus.util.StringUtils;

/**
 * Goal which touches a timestamp file.
 *
 * Here i a sample configuration for the plugin with the defaults:
 *             <plugin>
<groupId>net.sourceforge.pldoc</groupId>
<artifactId>maven-pldoc-plugin</artifactId>
<version>2.0-SNAPSHOT</version>
<configuration>
<applicationTitle>project-name</applicationTitle>
<sourceDirectory>src/sql</sourceDirectory>
<includes>*.sql</includes>
<reportOutputDirectory>target/site/apidocs</reportOutputDirectory>
</configuration>                    
</plugin>

 *
 * @goal pldoc
 * @phase pldoc
 * @execute phase="generate-sources"
 *
 */
public class PLDoc
        extends AbstractMojo
implements MavenReport{

    /**
     * The name of the destination directory.
     * <br/>
     *
     * @since 2.1
     * @parameter expression="${destDir}" default-value="sql-apidocs"
     */
    private String destDir;

    /**
     * Specifies the destination directory where pldoc saves the generated HTML files.

     *
     * @parameter expression="${destDir}" alias="destDir" default-value="${project.build.directory}/sql-apidocs"
     * @required
     */
    protected File outputDirectory;

    /**
     * Specifies the destination directory where pldoc saves the generated HTML files.
     *
     * @parameter expression="${project.reporting.outputDirectory}/sql-apidocs"
     * @required
     */
    private File reportOutputDirectory;
    
    /**
     * Specifies the source directory
     *
     * @parameter expression="${sourceDirectory}" default-value="${basedir}/src/sql"
     * @required
     */
    private File sourceDirectory;

    /**
     * Specifies the included files
     *
     * @parameter expression="${includes}" default-value="*.sql"
     * @required
     */
    private String includes;
    /**
     * Specifies the application title
     *
     * @parameter expression="${application.title}" default-value="${project.name}"
     * @required
     */
    private String applicationTitle;
    /**
     * The Maven Project Object
     *
     * @parameter expression="${project}"
     * @required
     * @readonly
     */
    private MavenProject project;


    /**
     * The name of the Javadoc report.
     *
     * @since 2.1
     * @parameter expression="${name}"
     */
    private String name;

    /**
     * The description of the Javadoc report.
     *
     * @since 2.1
     * @parameter expression="${description}"
     */
    private String description;


    public void execute()
            throws MojoExecutionException {
        PLDocTask task = new PLDocTask();
        task.init();
        task.setDestdir(reportOutputDirectory);
        task.setDoctitle(applicationTitle);
        FileSet fset = new FileSet();
        fset.setDir(sourceDirectory);
        fset.setIncludes(includes);
        task.addFileset(fset);
        Project proj = new Project();
        proj.setBaseDir(reportOutputDirectory);
        proj.setName(applicationTitle);
        task.setProject(proj);
        task.execute();

    }

    public void generate(Sink arg0, Locale arg1) throws MavenReportException {
        try {
            execute();
        } catch (MojoExecutionException ex) {
            throw new MavenReportException("Failed generating pldoc report",ex);
        }
    }

    public String getOutputName() {
        return destDir + "/index";
    }

    public String getName(Locale locale) {
        if ( StringUtils.isEmpty( name ) )
        {
            return getBundle( locale ).getString( "report.pldoc.name" );
        }

        return name;
    }

    public String getCategoryName() {
        return CATEGORY_PROJECT_REPORTS;
    }

    public String getDescription(Locale locale) {
        if ( StringUtils.isEmpty( description ) )
        {
            return getBundle( locale ).getString( "report.pldoc.description" );
        }

        return description;
    }

    public void setReportOutputDirectory(File reportOutputDirectory) {
        if ( ( reportOutputDirectory != null ) && ( !reportOutputDirectory.getAbsolutePath().endsWith( destDir ) ) )
        {
            this.reportOutputDirectory = new File( reportOutputDirectory, destDir );
        }
        else
        {
            this.reportOutputDirectory = reportOutputDirectory;
        }
    }

    public File getReportOutputDirectory() {
        if ( reportOutputDirectory == null )
        {
            return outputDirectory;
        }
        return reportOutputDirectory;
    }

    public boolean isExternalReport() {
         return true;
    }

    public boolean canGenerateReport() {
        return true;
    }

     /**
     * Gets the resource bundle for the specified locale.
     *
     * @param locale The locale of the currently generated report.
     * @return The resource bundle for the requested locale.
     */
    private ResourceBundle getBundle( Locale locale )
    {
        return ResourceBundle.getBundle( "pldoc-report", locale, getClass().getClassLoader() );
    }


}
