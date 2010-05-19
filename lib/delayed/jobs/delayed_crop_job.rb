class DelayedCropJob < Struct.new(:instance_klass, :instance_id, :attachment_name,:crop_x ,:crop_y ,:crop_w ,:crop_h )
  def perform
    process_job do
      instance.send(attachment_name).reprocess!
      instance.send("#{attachment_name}_processed!")
    end
  end
  
  private
  def instance
    @instance ||= instance_klass.constantize.find(instance_id)
    @instance.crop_x ,@instance.crop_y ,@instance.crop_w , @instance.crop_h = crop_x , crop_y , crop_w , crop_h
    @instance
  end
  
  def process_job
    instance.send(attachment_name).job_is_processing = true
    yield
    instance.send(attachment_name).job_is_processing = false    
  end
end
