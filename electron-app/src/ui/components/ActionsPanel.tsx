import React, { useState } from 'react';
import { useElectron } from '../context/ElectronContext';
import { WriterModal } from './WriterModal';

export function ActionsPanel() {
  const { scenario, executeReader } = useElectron();
  const [writerModalOpen, setWriterModalOpen] = useState(false);
  const [selectedWriter, setSelectedWriter] = useState<{ id: string; name: string } | null>(null);

  const handleReaderClick = (readerId: string) => {
    executeReader(readerId);
  };

  const handleWriterClick = (writerId: string, writerName: string) => {
    setSelectedWriter({ id: writerId, name: writerName });
    setWriterModalOpen(true);
  };

  const readers = scenario?.readers || [];
  const writers = scenario?.writers || [];

  return (
    <>
      <div className="bg-white rounded-lg shadow p-4">
        <h2 className="text-lg font-semibold mb-3">Actions</h2>
        
        {/* Readers */}
        <div className="mb-4">
          <h3 className="text-sm font-medium text-gray-700 mb-2">Readers</h3>
          <div className="space-y-2">
            {readers.length > 0 ? (
              readers.map((reader) => (
                <button 
                  key={reader.id}
                  onClick={() => handleReaderClick(reader.id)}
                  className="w-full text-left px-3 py-2 bg-blue-50 hover:bg-blue-100 border border-blue-200 rounded text-sm"
                >
                  <div className="font-medium">{reader.name}</div>
                  <div className="text-xs text-gray-600">{reader.description}</div>
                </button>
              ))
            ) : (
              <p className="text-sm text-gray-500">No readers available for current page</p>
            )}
          </div>
        </div>

        {/* Writers */}
        <div>
          <h3 className="text-sm font-medium text-gray-700 mb-2">Writers</h3>
          <div className="space-y-2">
            {writers.length > 0 ? (
              writers.map((writer) => (
                <button 
                  key={writer.id}
                  onClick={() => handleWriterClick(writer.id, writer.name)}
                  className="w-full text-left px-3 py-2 bg-green-50 hover:bg-green-100 border border-green-200 rounded text-sm"
                >
                  <div className="font-medium">{writer.name}</div>
                  <div className="text-xs text-gray-600">{writer.description}</div>
                </button>
              ))
            ) : (
              <p className="text-sm text-gray-500">No writers available for current page</p>
            )}
          </div>
        </div>
      </div>

      {selectedWriter && (
        <WriterModal 
          isOpen={writerModalOpen}
          onClose={() => {
            setWriterModalOpen(false);
            setSelectedWriter(null);
          }}
          writerId={selectedWriter.id}
          writerName={selectedWriter.name}
        />
      )}
    </>
  );
}

