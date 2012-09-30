module ExamsHelper
  def render_to_xls(students,name,exam_groups,subjects,grouped_exam,terms,batch)

    book = Spreadsheet::Workbook.new
    data = book.create_worksheet :name => name
    index3 = 4
    personal_index=0
    index=0
    exam_group_inde=0
    students.each_with_index do |student,k|
      data.row(index).replace ["#{SchoolConfiguration.find_by_config_key("InstitutionName").config_value}"]
      data.row(index).height = 20
      data.row(index+1).replace ["#{SchoolConfiguration.find_by_config_key("InstitutionAddress").config_value}"]
      data.row(index+2).replace ["PROGRESS REPORT"]
      header_format = Spreadsheet::Format.new :color => :black, :weight => :bold
      bold = Spreadsheet::Format.new :weight => :bold,:horizontal_align=> :center
      data.row(index+3).default_format=bold
      data.row(index+3).concat ["Name : #{student.full_name}","","Roll No.","#{student.class_roll_no}","Adm. No.","#{student.admission_no}","Class","#{student.batch.full_name}", "Session","#{current_session.name}"  ]
      remark_format = Spreadsheet::Format.new :horizontal_align=> :left,:vertical_align=>:top,:text_wrap => true
      data.column(0).width = 30
      data.column(7).width = 15
      merge = Spreadsheet::Format.new :align => :merge,:size => 18

      12.times do |x| data.row(index).set_format(x, merge) end
      alignment = Spreadsheet::Format.new :align => :merge
      left_alignment = Spreadsheet::Format.new :align => :merge,:weight=>:bold,:horizontal_align=> :left
      12.times do |x| data.row(index+1).set_format(x, alignment) end
      12.times do |x| data.row(index+2).set_format(x, alignment) end
      2.times do |x| data.row(index+3).set_format(x, left_alignment) end
      data.row(index+5).default_format = header_format
      data.row(index+4).default_format = header_format

      subjects.each_with_index do |subject,i|
        index3 = index3 + 1
        puts "the index on subject first is#{index3}"
        data[index3,0]=subject.name
        data.row(index3).set_format(0, header_format)
        subject.topics.each_with_index do |topic,j|
        #               now i am filling the data
          exam_groups.each_with_index do |exam_group,exam_group_index|
            exam_group_inde=exam_group_index+1
            data[index+5,exam_group_inde] = exam_group.assessment_name.name
            @exam = Exam.find_by_topic_id_and_exam_group_id(topic.id,exam_group.id)
            exam_score = ExamScore.find_by_student_id(student.id, :conditions=>{:exam_id=>@exam.id})unless @exam.nil?
            unless @exam.nil?
              if exam_group.exam_type == "MarksAndGrades" || exam_group.exam_type == "Grades"
                unless exam_score.nil?
                  grade=exam_score.grading_level_detail.grading_level_detail_name unless exam_score.grading_level_detail.nil?
                  if subject.name==topic.name
                  data[index3,exam_group_inde]=grade
                  else
                  data[index3+1,exam_group_inde]=grade
                  end

                data.row(index3+1).set_format(exam_group_inde, bold)
                else
                  data[index3+1,exam_group_inde]=""
                end
              end
            else
              if subject.name==topic.name
                data[index3,exam_group_inde]="N.A"
              else
                data[index3+1,exam_group_inde]="N.A"
              end
            end
          end
          #               this is my filled data

          if subject.name==topic.name
            data[index3,0]= topic.name
            data.row(index3).set_format(0, Spreadsheet::Format.new)
          else
          index3 = index3 + 1
          data[index3,0]= topic.name
          end

        end
      end
      term_indxe=0

      terms.uniq.each_with_index do |term,term_index|

        data[index+4,exam_group_inde+term_index+5] = term.name
        student_co_scholastic_assessment=StudentCoScholasticAssessment.find_by_batch_id_and_term_master_id(batch.id,term.id)
        student_co_scholastic_area_assessments=StudentCoScholasticAreaAssessmentDetail.find_all_by_student_co_scholastic_assessment_id_and_student_id(student_co_scholastic_assessment.id,student.id)
       student_co_scholastic_area_assessments.each do |x| data[index+5+term_indxe,exam_group_inde+3]=x.co_scholastic_sub_skill_area.co_scholastic_area.co_scholastic_area_name end
        data.merge_cells(index+5+term_index, exam_group_inde+3,index+5+term_index,exam_group_inde+4)

        student_co_scholastic_area_assessments.each_with_index do |p,p1|
          data[index+6+p1,exam_group_inde+3] = p.co_scholastic_sub_skill_area.co_scholastic_sub_skill_name
          data[index+6+p1,exam_group_inde+term_index+5] = p.assessment_indicator.indicator_value
          data.merge_cells(index+6+p1, exam_group_inde+3, index+6+p1, exam_group_inde+4)
          term_indxe=index+6+p1
        end
      end
      #         remark
      student_term_remarks=StudentTermRemark.find_all_by_batch_id_and_student_id(batch.id,student.id)
      student_remark_terms=[]
      unless student_term_remarks.empty?
        student_term_remarks.each do |student_term_remark|
          student_remark_terms << TermMaster.find_by_id(student_term_remark.term_master_id)
        end
        term_in=term_indxe
        unless term_indxe==0
          student_remark_terms.each_with_index do |term,term_index|
          data[term_in+1,exam_group_inde+3] = "Remark:"+term.name
          data.row(term_in+1).set_format(exam_group_inde+3, header_format)
          data.row(term_in+2).set_format(exam_group_inde+3, remark_format)
          data[term_in+2,exam_group_inde+3]= StudentTermRemark.find_by_term_master_id_and_student_id(term.id,student.id).remarks
          data.merge_cells(term_in+2, exam_group_inde+3, term_in+6,exam_group_inde+terms.count+4)
          term_in=term_in+8
         
         
        end
      else
         t=0
        student_remark_terms.each_with_index do |term,term_index|
         
          data[index+6+term_indxe+t,exam_group_inde+3] = "Remark:"+term.name
          data.row(index+6+term_indxe+t).set_format(exam_group_inde+3, header_format)
          data.row(index+6+term_indxe+t+1).set_format(exam_group_inde+3, remark_format)
          data.merge_cells(index+6+term_indxe+t+1, exam_group_inde+3, index+6+term_indxe+t+5,exam_group_inde+terms.count+4)
          
          data[index+6+term_indxe+t+1,exam_group_inde+terms.count+4]=StudentTermRemark.find_by_term_master_id_and_student_id(term.id,student.id).remarks
          
          t=t+8
        end
       end
      end

      
      # remark
      index =index3 + 12
      data.row(index3+4).set_format(0, header_format)
      data[index3+4,0]="Attandence"
      data.row(index3+6).set_format(0, header_format)
       data.merge_cells(index3+6, 0, index3+6,1)
      data[index3+6,0]="Class Teachers`s Signature"
      data.row(index3+6).set_format(4, header_format)
       data.merge_cells(index3+6, 4, index3+6,7)
      data[index3+6,4]="Principal`s Signature"
      data.row(index3+6).set_format(9, header_format)
       data.merge_cells(index3+6, 9, index3+6,11)
      data[index3+6,9]="Parent`s Signature"
      data.row(index3+8).set_format(9, header_format)
      data.merge_cells(index3+8, 9, index3+8,12)
      data[index3+8,9]="Note:- ABS*- Medical Certificate Given"
      index3 =index + 5
    end
    blob = StringIO.new('')
    book.write(blob)
    blob.rewind
    blob.read
  end
  
  
   def render_report_card(students,name,exam_groups,subjects,grouped_exam,terms,batch)

    book = Spreadsheet::Workbook.new
    default_format = Spreadsheet::Format.new :color => :black, :size => 8 
    book.default_format = default_format
    data = book.create_worksheet :name => name
    index3 = 4
    personal_index=0
    index=0
    main_index=0
    exam_group_inde=0
    students.each_with_index do |student,k|
      if k==0
        index3=index3+1
      end
      # data.row(index).replace ["#{SchoolConfiguration.find_by_config_key("InstitutionName").config_value}"]
      # data.row(index).height = 20
      # data.row(index+1).replace ["#{SchoolConfiguration.find_by_config_key("InstitutionAddress").config_value}"]
      # data.row(index+2).replace ["PROGRESS REPORT"]
      header_format = Spreadsheet::Format.new :color => :black, :weight => :bold, :size => 8
      bold = Spreadsheet::Format.new :weight => :bold,:horizontal_align => :center, :size => 8
      data.row(index).default_format=bold
     
      data.row(index).concat ["Name : #{student.full_name}","Roll No.","#{student.class_roll_no}","Adm. No.","#{student.admission_no}","Class","#{student.batch.full_name}", "Session","#{current_session.name}"  ]
       data.row(index+1).set_format(0, header_format)
      data[index+1,0]="Part1: Scholastic Area"
      remark_format = Spreadsheet::Format.new :horizontal_align => :left, :vertical_align => :top, :text_wrap => true, :size => 8
      data.column(0).width = 30
      data.column(6).width = 15
      merge = Spreadsheet::Format.new :align => :merge, :size => 18
      alignment = Spreadsheet::Format.new :align => :merge
      left_alignment = Spreadsheet::Format.new :align => :merge,:weight=>:bold,:horizontal_align=> :left, :size => 8
      # 12.times do |x| data.row(index+1).set_format(x, alignment) end
      # 12.times do |x| data.row(index+2).set_format(x, alignment) end
      2.times do |x| data.row(index).set_format(x, left_alignment) end
      data.row(index+2).default_format = header_format
      
       data[index+2,0] ="Subject"
       subject_index=index+2
      subjects.each_with_index do |subject,i|
            subject_index = subject_index + 1
            data.row(subject_index).set_format(0, header_format)
           data[subject_index,0]=subject.name.upcase
           subject.topics.each_with_index do |topic,j|
        #               now i am filling the data
        term_id=0
        term_in=-2
        term_count=1
        assessment=""
        @to_obta=0
        @sub_aggr =0
         @to_mto=0
        weight=0.0
        exam_groups.each_with_index do |exam_group,exam_group_index|
            greid =  ConnectExam.find_by_exam_group_id_and_grouped_exam_id(exam_group.id,grouped_exam.id)
            weightage= greid.weightage
            weight=weight+weightage
            assessment=assessment+exam_group.assessment_name.name+'+'
            exam_group_inde=exam_group_index+1
            # data.row(index+1).set_format(exam_groups.count+1, remark_format)
             data[index+2,exam_groups.count+1] ="Total(#{assessment})#{weight.to_s}%"
            
         if term_id != exam_group.term_master_id
          data.merge_cells(index+1, term_in+3, index+1,exam_groups.count+1)
          data.row(index+1).default_format = bold
          data[index+1,term_in+3]=TermMaster.find_by_id(exam_group.term_master_id).name
          data.column(term_in+3).width = 15
          data[index+2,term_in+3] ="#{exam_group.assessment_name.name}(#{weightage.to_s unless weightage.nil?}%)"
           @exam = Exam.find_by_topic_id_and_exam_group_id(topic.id,exam_group.id)
            exam_score = ExamScore.find_by_student_id(student.id, :conditions=>{:exam_id=>@exam.id})unless @exam.nil?
             unless @exam.nil?
               if exam_group.exam_type == "MarksAndGrades" || exam_group.exam_type == "Grades"
                    unless exam_score.nil?
                      grade=exam_score.grading_level_detail.grading_level_detail_name unless exam_score.grading_level_detail.nil?
                      @obt = exam_score.marks 
                      @tot = @exam.maximum_marks
                       @to_obta +=@obt unless @obt.nil?
                      @to_mto +=@tot
                      unless @obt.nil? or @tot.nil?
                        @sub_per = @obt*100/@tot
                        unless greid.nil?
                          @sub_p = @sub_per* greid.weightage/100
                          else
                            @sub_p = 0
                            end
                      @sub_aggr += @sub_p 
                      end
                        if subject.name==topic.name
                        data[subject_index,exam_group_inde]=grade
                        percentage_to_be_grade=@sub_aggr*100/weight
                        grade=GradingLevelDetail.percentage_to_grade(percentage_to_be_grade, grouped_exam.grading_level_group.id)
                         data[subject_index,exam_group_inde+1]= grade.grading_level_detail_name
                        data.row(subject_index).set_format(exam_group_inde, bold)
                        else
                        data[subject_index+1,exam_group_inde]=grade
                        data.row(subject_index+1).set_format(exam_group_inde, bold)
                        end
    
                    
                    else
                      data[subject_index+1,exam_group_inde]=""
                    end
                end
            else
                if subject.name==topic.name
                  data[subject_index,exam_group_inde]="N.A"
                else
                  data[subject_index+1,exam_group_inde]="N.A"
                end
            end
          term_count=term_count+1
        else
         data[index+2,term_count] ="#{exam_group.assessment_name.name}(#{weightage.to_s unless weightage.nil?}%)"
          @exam = Exam.find_by_topic_id_and_exam_group_id(topic.id,exam_group.id)
            exam_score = ExamScore.find_by_student_id(student.id, :conditions=>{:exam_id=>@exam.id})unless @exam.nil?
              unless @exam.nil?
               if exam_group.exam_type == "MarksAndGrades" || exam_group.exam_type == "Grades"
                      unless exam_score.nil?
                              grade=exam_score.grading_level_detail.grading_level_detail_name unless exam_score.grading_level_detail.nil?
                              @obt = exam_score.marks 
                              @tot = @exam.maximum_marks
                               @to_obta +=@obt unless @obt.nil?
                              @to_mto +=@tot
                              unless @obt.nil? or @tot.nil?
                              @sub_per = @obt*100/@tot
                               unless greid.nil?
                               @sub_p = @sub_per* greid.weightage/100
                             else
                              @sub_p = 0
                            end
                            @sub_aggr += @sub_p 
                      end
                              
                              if subject.name==topic.name
                              data[subject_index,exam_group_inde]=grade
                              percentage_to_be_grade=@sub_aggr*100/weight
                             grade=GradingLevelDetail.percentage_to_grade(percentage_to_be_grade, grouped_exam.grading_level_group.id)
                              data.row(subject_index).set_format(exam_group_inde+1, bold)
                               data[subject_index,exam_group_inde+1]= grade.grading_level_detail_name
                              else
                              data[subject_index+1,exam_group_inde]=grade
                              end
                            data.row(subject_index).set_format(exam_group_inde, bold)
                            data.row(subject_index+1).set_format(exam_group_inde, bold)
                      else
                        data[subject_index+1,exam_group_inde]=""
                      end
                end
            else
                if subject.name==topic.name
                  data[subject_index,exam_group_inde]="N.A"
                else
                  data[subject_index+1,exam_group_inde]="N.A"
                end
            end
         term_count=term_count+1
        end
         data.column(term_count).width = 15
         term_in=term_in+exam_group_index
         term_id=exam_group.term_master_id
        
        
         end
          if subject.name==topic.name
            data[subject_index,0]= topic.name.upcase
            same_name=Spreadsheet::Format.new :size=>8
            data.row(subject_index).set_format(0,same_name )
          else
          subject_index = subject_index + 1
          data[subject_index,0]= topic.name.upcase
          end

        end
      end
     

   
      #         remark
      activity_count=0
       activity=0
      
       term_indxe=subject_index
       scholastic_assessment=subject_index
       terms.uniq.each_with_index do |term,term_index|
        
         student_co_scholastic_assessment=StudentCoScholasticAssessment.find_by_batch_id_and_term_master_id(batch.id,term.id)
         student_co_scholastic_area_assessments=StudentCoScholasticAreaAssessmentDetail.find_all_by_student_co_scholastic_assessment_id_and_student_id(student_co_scholastic_assessment.id,student.id)
         student_term_remarks=StudentTermRemark.find_all_by_batch_id_and_student_id_and_term_master_id(batch.id,student.id,term.id)
         data.row(scholastic_assessment+1).set_format(0, header_format)
         # data.row(scholastic_assessment+1).set_format(1, header_format)
         data.merge_cells(scholastic_assessment+1, 0, scholastic_assessment+1, 1)
         data[scholastic_assessment+1,0]= "PART 2: CO-Scholastic Areas"
         data.row(scholastic_assessment+2).set_format(2, bold)
         data[scholastic_assessment+2,2]= "Grade"
         
          
      
         @batch.course.co_scholastic_areas.each_with_index do |co_scholastic_area,i|
           
           scol=scholastic_assessment+i
            data.row(scol+2).set_format(0, header_format)
            data.merge_cells(scol+2, 0, scol+2, 1)
               data[scol+2,0]="#{}#{co_scholastic_area.co_scholastic_area_name.upcase}"
              co_scholastic_area.co_scholastic_sub_skill_areas.each_with_index do |co_scholastic_sub_skill_area,index| 
                    data[scholastic_assessment+3+i,0]= co_scholastic_sub_skill_area.co_scholastic_sub_skill_name.upcase
                   area_detail= StudentCoScholasticAreaAssessmentDetail.find_by_student_id_and_co_scholastic_sub_skill_area_id(student.id,co_scholastic_sub_skill_area.id)
                      data.row(scholastic_assessment+3+i).set_format(2, bold)
                      data.merge_cells(scholastic_assessment+3+i, 0, scholastic_assessment+3+i, 1)
                     data[scholastic_assessment+3+i,2]=area_detail.assessment_indicator.indicator_value unless area_detail.nil?
                    scholastic_assessment=scholastic_assessment+1
                    activity=scholastic_assessment+3+i
              end
              
         end
       
         data.row(activity).set_format(0, header_format)
         data.merge_cells(activity, 0, activity, 1)
         data[activity,0]= "PART 3: CO-Scholastic Activities"
         data.row(activity+1).set_format(2, bold)
         data[activity+1,2]= "Grade"
          
          @batch.course.co_scholastic_activities.each_with_index do |co_scholastic_activity,i|
            
               data.row(activity+1+i).set_format(0, header_format)
               data.merge_cells(activity+1+i, 0, activity+1+i, 1)
               data[activity+1+i,0]=co_scholastic_activity.co_scholastic_activity_name.upcase
               co_scholastic_activity.co_scholastic_sub_skill_activities.each do |co_scholastic_sub_skill_activity|
               data.merge_cells(activity+2+i, 0, activity+2+i, 1)
               data[activity+2+i,0]=co_scholastic_sub_skill_activity.co_scholastic_sub_skill_name.upcase
               activity_detail= StudentCoScholasticActivityAssessmentDetail.find_by_student_id_and_co_scholastic_sub_skill_activity_id(student.id,co_scholastic_sub_skill_activity.id)
               data.row(activity+2+i).set_format(2, bold)
               
               data[activity+2+i,2]=activity_detail.co_scholastic_activity_assessment_indicator.indicator_value unless activity_detail.nil?
               activity_count=activity+2+i
               activity=activity+1
                
             end
             
          end
      
      unless student_term_remarks.empty?
       
       
        student_term_remarks.each do |student_term_remark|
          data.row(term_indxe+1).set_format(exam_groups.count+2, remark_format)
          data.merge_cells(term_indxe+1,exam_groups.count+2,term_indxe+2,exam_groups.count+6)
          data[term_indxe+1,exam_groups.count+2]="#{student_term_remark.remarks_type}: #{student_term_remark.remarks}"
          term_indxe=term_indxe+2
        end
       
      end
     end
    
      if terms.count==0
      footer_index=subject_index+1
     else
       footer_index=activity_count+@batch.course.co_scholastic_activities.count   
     end
  
      # remark
     
         index =footer_index+4
         data.row(footer_index).set_format(0, header_format)
       data[footer_index,0]="Attandence"
       data.row(footer_index+1).set_format(0, header_format)
       data.merge_cells(footer_index+1, 0, footer_index+2,1)
       data[footer_index+1,0]="Class Teachers`s Signature"
       data.row(footer_index+1).set_format(4, header_format)
       data.merge_cells(footer_index+1, 4, footer_index+2,6)
       data[footer_index+1,4]="Principal`s Signature"
       data.row(footer_index+1).set_format(9, header_format)
       data.merge_cells(footer_index+1, 9, footer_index+2,11)
       data[footer_index+1,9]="Parent`s Signature"
       data.row(footer_index+3).set_format(9, header_format)
       data.merge_cells(footer_index+3, 9, footer_index+3,12)
       data[footer_index+3,9]="Note:- ABS*- Medical Certificate Given"
       subject_index =index + 5
       
       
    end
    
    blob = StringIO.new('')
    book.write(blob)
    blob.rewind
    blob.read
  end
  
  
  
  
end
 





